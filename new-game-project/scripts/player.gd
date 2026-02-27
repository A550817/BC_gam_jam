class_name Player extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

@export var drag_strength: float = 0.5
@export var speed: int = 100
@export var radius: float = 50.0
@export var color: Color = Color.CYAN
@export var is_controller: bool = false
@export var texture: CompressedTexture2D

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
var last_dmg: int = 0

func _ready() -> void:
	if texture:
		sprite_2d.texture = texture
	initialize_states()

func _input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func _physics_process(delta: float) -> void:
	velocity *= clamp(1.0 - drag_strength * delta, 0.0, 1.0)
	change_state(current_state.physics_process(delta))
	var collision := move_and_collide(velocity*delta);
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		damage_test(collision.get_collider())
		change_state(%IdleState)
	
	controller_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	


func _process(delta: float) -> void:
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


func _draw() -> void:
	pass

func damage_test(body: Node2D) -> void:
	if body is CharacterBody2D && body.has_method("take_damage"):
		var length = (body.velocity - velocity).length()
		last_dmg = Time.get_ticks_msec()
		body.last_dmg = Time.get_ticks_msec()
		if body.velocity < velocity:
			print_debug("OTHER!")
			body.take_damage(length*0.1)
		elif body.velocity > velocity:
			print_debug("THIS!")
			take_damage(length*0.1)


func take_damage(dmg: int):
	if !Time.get_ticks_msec() > last_dmg + 1000:
		return
	health -= dmg
	update_radius()
	print_debug(health)
	if health <= 0:
		queue_free()
		

func update_radius():
	$CollisionShape2D.apply_scale(Vector2(max_health/health, max_health/health))
	$Sprite2D.apply_scale(Vector2(max_health/health, max_health/health))
