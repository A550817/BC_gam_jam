extends CanvasLayer




func _on_back_button_pressed() -> void:
	TransitionLayer.change_scene(load("res://scenes/StartScreen.tscn"))
