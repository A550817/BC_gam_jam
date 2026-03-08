extends Node2D

var is_paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if is_paused:
		$CanvasLayer/ContinueButton.hide()
		$CanvasLayer/BackButton.hide()
		$CanvasLayer/AnimationPlayer.play("fade_out")
		await $CanvasLayer/AnimationPlayer.animation_finished
		get_tree().paused = false
	else:
		get_tree().paused = true
		$CanvasLayer/AnimationPlayer.play("fade_in")
		$CanvasLayer/ContinueButton.show()
		$CanvasLayer/BackButton.show()

	
	is_paused = !is_paused


func _on_continue_button_pressed() -> void:
	toggle_pause()


func _on_back_button_pressed() -> void:
	get_tree().paused = false
	print(ResourceLoader.exists("res://scenes/StartScreen.tscn"))
	TransitionLayer.change_scene(load("res://scenes/StartScreen.tscn"))
