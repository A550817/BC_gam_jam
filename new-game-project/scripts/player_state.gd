class_name PlayerState extends Node


var player : Player
var next_state : PlayerState


#region /// state_reference
#reference to all other states
@onready var idle_state: PlayerStateIdle = %IdleState
@onready var tether_state: PlayerStateTether = %TetherState
@onready var hurt_state: PlayerStateHurt = %HurtState
@onready var ray_cast_2d: RayCast2D = %RayCast2D

#endregion


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
