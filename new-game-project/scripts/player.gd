@tool
class_name Player extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

@export var small_hit_sounds: Array[AudioStream]
@export var heavy_hit_sounds: Array[AudioStream]
@export var drag_strength: float = 0.5
@export var speed: int = 100
@export var is_controller: bool = false
@export var texture: CompressedTexture2D:
	set(value):
		texture = value
		update_texture()

#region /// StateMachineVariables
var states: Array = [PlayerState]

var current_state: PlayerState:
	get:
		return states.front()

var previous_state: PlayerState:
	get:
		return states[1]
#endregion


@export var max_health: int = 100
var health: int = max_health
var controller_direction: Vector2

func _ready() -> void:
	update_texture()
	if Engine.is_editor_hint():
		return
	
	initialize_states()

func _input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	velocity *= clamp(1.0 - drag_strength * delta, 0.0, 1.0)
	change_state(current_state.physics_process(delta))
	var collision := move_and_collide(velocity * delta)
	if collision:
		var current_scale: float = scale.x
		var impact_force: float = velocity.length() / current_scale
		var shake_amount: float = clamp(impact_force * 0.15, 6.0, 18.0)
		$"../Camera2D".shake(shake_amount)
		play_hit_sound(impact_force)
		if impact_force >= 900:
			$HitParticles.amount = 8
		else:
			$HitParticles.amount = 4
		$HitParticles.global_position = global_position
		$HitParticles.restart()
		velocity = velocity.bounce(collision.get_normal())
		change_state(%IdleState)
	clamp_velocity()
	if collision:
		if collision.get_collider() is RigidBody2D:
			var body := collision.get_collider()
			body.apply_impulse(velocity * 0.1)
			apply_children_scale(-4, -16, body)
			var timer := get_tree().create_timer(0.1)
			timer.timeout.connect(func():
				apply_children_scale(0, 0, body)
			)
	
	
	if Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down") != Vector2.ZERO:
		controller_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down").normalized()
	
	


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var s: float = clamp(scale.x, 0.3, 1.0)
	var max_speed: float = 3000.0 * pow(1.0 / s, 1.2)
	
	if !is_controller:
		$ReticleRotate.rotation = (get_global_mouse_position()-position).angle()
	else:
		$ReticleRotate.rotation = controller_direction.angle()
	
	change_state(current_state.process(delta))
	


#region /// State Machine Setup
func initialize_states():
	states = []
	
	# gather all states
	for state in $States.get_children():
		if state is PlayerState:
			states.append(state)
			state.player = self
	
	if states.size() == 0:
		return
	
	# initialize states
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()


func change_state(new_state: PlayerState):
	if new_state == null:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	change_state(current_state.enter())
	states.resize(3)
#endregion


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		if get_instance_id() < body.get_instance_id():
			resolve_combat(body)


func take_damage(velocity: Vector2):
	

	# --- Calculate impact force ---
	var current_scale: float = scale.x
	var impact_force: float = velocity.length() / current_scale
	print(impact_force)
	
	# Convert impact to damage
	var damage: int = int(impact_force * 0.005)
	damage = clamp(damage, 4, 30) # Prevent zero damage & absurd spikes
	
		# Convert impact to shake
	var shake_amount: float = clamp(impact_force * 0.15, 6.0, 18.0)
	
	
	$"../Camera2D".shake(shake_amount)
	$HitParticles.global_position = global_position
	if impact_force >= 900:
		$HitParticles.amount = 8
	else:
		$HitParticles.amount = 4
	$HitParticles.restart()
	
	modulate = Color(1.4, 1.4, 1.4)
	await get_tree().create_timer(0.05).timeout
	modulate = Color(1,1,1)
	
	var base_scale := scale
	
	#scale *= 0.9
	#await get_tree().create_timer(0.05).timeout
	#scale = base_scale
	
	health -= damage
	health = clamp(health, 0, max_health)
	var ratio: float = float(health) / float(max_health)
	var visual_scale: float = lerp(0.6, 1.0, ratio)
	modulate.a = visual_scale
	scale = Vector2(visual_scale, visual_scale)
	print("Health:", health, " Scale:", scale.x)


func apply_children_scale(scale: float, visual_scale:float, target: Node2D):
	if not target:
		return
	
	if target.has_method("scale_children"):
		target.scale_children(scale, visual_scale)
		
		
func update_texture():
	if not is_node_ready():
		return
	sprite_2d.texture = texture


func resolve_combat(body: Node2D):
	var current_scale: float = scale.x
	var impact_force: float = velocity.length() / current_scale
	var damage: int = int(impact_force * 0.005)
	damage = clamp(damage, 4, 30)
	var base_velocity = velocity
	var base_modulate := modulate
	modulate *= 1.5
	velocity = Vector2(0,0)
	await get_tree().create_timer(damage*0.0175, true, false, true).timeout
	modulate = base_modulate
	velocity = base_velocity
	if body.velocity.length() < velocity.length():
		body.take_damage(velocity)
	elif body.velocity.length() > velocity.length():
		take_damage(body.velocity)
	else:
		body.take_damage(velocity)
		take_damage(body.velocity)


func get_speed_multiplier() -> float:
	var s: float = clamp(scale.x, 0.3, 1.0)
	return pow(1.0 / s, 1.5)


func clamp_velocity():
	var s: float = clamp(scale.x, 0.3, 1.0)
	var max_speed: float = 1500.0 * pow(1.0 / s, 1.2)
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


func play_hit_sound(impact_force: float):
	var player := $HitPlayer
	
	var sounds: Array[AudioStream]
	var is_heavy := impact_force > 900.0
	
	if is_heavy:
		sounds = heavy_hit_sounds
	else:
		sounds = small_hit_sounds
	
	if sounds.is_empty():
		return
	
	var index := randi() % sounds.size()
	player.stream = sounds[index]
	
	# Pitch variation
	player.pitch_scale = randf_range(0.98, 1.02)
	# Volume scaling
	var volume: float = clamp(impact_force / 900.0, 0.6, 1.2)
	player.volume_db = linear_to_db(volume)
	
	player.play()
