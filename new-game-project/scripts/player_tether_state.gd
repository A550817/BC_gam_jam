class_name PlayerStateTether extends PlayerState


var tether_point: Vector2 = Vector2.ZERO
var tether_length: float = 100.0
var pull_strength: float = 200.0
var drag_strength: float = 0.5

# What happens when this state is initialized
func init():
	pass


# What happens when we enter the state
func enter():
	ray_cast_2d.enabled = true
	var mouse = get_tree().get_root().get_mouse_position()
	ray_cast_2d.target_position = mouse
	ray_cast_2d.force_raycast_update()

	if ray_cast_2d.is_colliding():
		tether_point = ray_cast_2d.get_collision_point()
		tether_length = player.global_position.distance_to(tether_point)
	else:
		return idle_state


# What happens when we exit the the state
func exit():
	pass


# Handle input
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("click"):
		return idle_state
	return null


func process(delta: float) -> PlayerState:
	return null


func physics_process(delta: float) -> PlayerState:
	var to_anchor = tether_point - player.global_position
	var distance = to_anchor.length()

	if distance > tether_length:
		var direction = to_anchor.normalized()

		# Pull force
		var pull_force = direction * pull_strength * (distance - tether_length)
		player.velocity += pull_force * delta

		# HARD rope constraint (important)
		var correction = direction * (distance - tether_length)
		player.global_position += correction

	# Drag
	player.velocity *= (1.0 - drag_strength * delta)

	return null
