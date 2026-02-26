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
	var mouse_global = player.get_global_mouse_position()
	ray_cast_2d.target_position = mouse_global - ray_cast_2d.global_position
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
	var direction = to_anchor.normalized()

	# Strong pull toward anchor (this creates movement)
	player.velocity += direction * pull_strength * delta

	# Rope length constraint (keeps swing radius)
	if distance > tether_length:
		player.global_position = tether_point - direction * tether_length

		# Remove outward velocity so it doesn't explode
		var outward_velocity = direction * player.velocity.dot(direction)
		player.velocity -= outward_velocity

	# Drag
	player.velocity *= clamp(1.0 - drag_strength * delta, 0.0, 1.0)

	return null
