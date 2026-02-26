class_name PlayerStateIdle extends PlayerState


# What happens when this state is initialized
func init():
	pass


# What happens when we enter the state
func enter():
	player.velocity = Vector2.ZERO
	ray_cast_2d.enabled = false


# What happens when we exit the the state
func exit():
	pass


# Handle input
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("click"):
		return tether_state
	return null


func process(delta: float) -> PlayerState:
	return null


func physics_process(delta: float) -> PlayerState:
	return null
