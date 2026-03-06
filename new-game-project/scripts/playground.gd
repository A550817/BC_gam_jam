extends Node2D

var is_paused = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			$CanvasLayer/AnimationPlayer.play("fade_out")
			is_paused = false
		else:
			$CanvasLayer/AnimationPlayer.play("fade_in")
			is_paused = true
