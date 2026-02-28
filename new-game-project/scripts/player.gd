@tool
class_name Player extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D

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
		velocity = velocity.bounce(collision.get_normal())
		change_state(%IdleState)
	
	controller_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
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


func take_damage(damage: int, body):
	health -= damage
	health = clamp(health, 0, max_health)
	var ratio := float(health) / float(max_health)
	scale = Vector2(ratio, ratio)


func update_texture():
	if not is_node_ready():
		return
	sprite_2d.texture = texture


func resolve_combat(body: Node2D):
	if body.velocity.length() < velocity.length():
		body.take_damage(10, body)
	elif body.velocity.length() > velocity.length():
		take_damage(10, self)
	else:
		body.take_damage(10, body)
		take_damage(10, self)
