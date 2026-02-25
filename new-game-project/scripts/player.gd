class_name Player extends CharacterBody2D

@export var speed: int = 100
 

#region /// StateMachineVariables
var states: Array = [PlayerState]

var current_state: PlayerState:
	get:
		return states.front()

var previous_state: PlayerState:
	get:
		return states[1]
#endregion


@export var max_health: int = 10
var health: int = max_health


func _ready() -> void:
	initialize_states()

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func _physics_process(delta: float) -> void:
	move_and_slide()
	change_state(current_state.physics_process(delta))


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


#region /// State Machine Setup
func initialize_states():
	states = []
	
	# gather all states
	for state in $states.get_children():
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
	current_state.enter()
	states.resize(3)
#endregion
