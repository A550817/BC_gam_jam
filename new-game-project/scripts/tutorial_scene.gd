extends Node2D




func _on_back_button_pressed() -> void:
	TransitionLayer.change_scene(preload("res://scenes/StartScreen.tscn"))
