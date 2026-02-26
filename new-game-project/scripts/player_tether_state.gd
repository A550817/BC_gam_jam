class_name PlayerStateTether extends PlayerState


var tether_point: Vector2 = Vector2.ZERO
var tether_length: float = 100.0
@export var max_tether_length: float = 1000.0
@export var pull_strength: float = 100.0
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
	else:
		return idle_state
	return null


# What happens when we exit the the state
func exit():
	pass


# Handle input
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_released("click"):
		return idle_state
	return null


func process(delta: float) -> PlayerState:
	return null


func physics_process(delta: float) -> PlayerState:
	ray_cast_2d.target_position = tether_point - ray_cast_2d.global_position
	ray_cast_2d.force_raycast_update()
	
	var to_anchor = tether_point - player.global_position
	var distance = to_anchor.length()
	var direction = to_anchor.normalized()
	tether_length = max(0, tether_length - (pull_strength * delta))
	var targetpos = tether_point - direction * tether_length
	
	var colinear_pull = abs(tether_length - distance) * direction * delta * 100
	player.velocity += colinear_pull
		
	$"../../../Sprite2D".position = targetpos
	
	return null
