class_name PlayerStateTether extends PlayerState


var tether_point: Vector2 = Vector2.ZERO
var tether_length: float = 100.0
@export var max_tether_length: float = 650.0
@export var radial_pull_strength: float = 100.0
@export var pull_speed: float = 100.0
@export var constraint_strength: float = 2

# What happens when this state is initialized
func init():
	pass


# What happens when we enter the state
func enter() -> PlayerState:
	ray_cast_2d.enabled = true
	if not player.is_controller:
		var mouse_global = player.get_global_mouse_position()
		var mouse_vec = mouse_global
		ray_cast_2d.target_position = (mouse_global - ray_cast_2d.global_position).normalized() * max_tether_length
	else:
		ray_cast_2d.target_position = player.controller_direction * max_tether_length
	ray_cast_2d.force_raycast_update()

	if ray_cast_2d.is_colliding():
		tether_point = ray_cast_2d.get_collision_point()
		tether_length = player.global_position.distance_to(tether_point)
		var collider = ray_cast_2d.get_collider()
		apply_random_scale(collider)
	else:
		return idle_state
	return null


# What happens when we exit the the state
func exit():
	pass


# Handle input
func handle_input(event: InputEvent) -> PlayerState:
	if player.is_controller:
		if event.is_action_released("controller_click"):
			return idle_state
	else:
		if event.is_action_released("mouse_click"):
			return idle_state
	return null


func process(delta: float) -> PlayerState:
	return null


func physics_process(delta: float) -> PlayerState:
	
	var to_anchor = tether_point - player.global_position
	var distance = to_anchor.length()
	var direction = to_anchor.normalized()

	var radial_pull = radial_pull_strength * direction * delta * 10
	player.velocity += radial_pull
	
	return null


func apply_random_scale(target: Node2D):
	if not target:
		return
	
	if target is CharacterBody2D:
		return
	
	# scale collision 
	var collision_shape := target.get_node_or_null("CollisionShape2D")
	if not collision_shape or not collision_shape.shape:
		return
	
	collision_shape.shape = collision_shape.shape.duplicate()
	
	var rect := collision_shape.shape as RectangleShape2D
	if not rect:
		return
	
	var multiplier := 1.1 if randf() < 0.5 else 0.9
	
	rect.size *= multiplier
	
	rect.size.x = max(rect.size.x, 10)
	rect.size.y = max(rect.size.y, 10)
	
	# scale sprite
	var sprite := target.get_node_or_null("Sprite2D")
	if sprite:
		sprite.scale *= multiplier
	
	sprite.scale.x = max(sprite.scale.x, 0.2)
	sprite.scale.y = max(sprite.scale.y, 0.2)
