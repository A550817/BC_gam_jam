class_name PlayerStateHurt extends PlayerState


# What happens when this state is initialized
func init():
	pass


# What happens when we enter the state
func enter():
	pass


# What happens when we exit the the state
func exit():
	pass


# Handle input
func handle_input(event: InputEvent) -> PlayerState:
	return null


func process(delta: float) -> PlayerState:
	return null


func physics_process(delta: float) -> PlayerState:
	return null
