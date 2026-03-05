extends CanvasLayer




func _on_start_button_pressed() -> void:
	TransitionLayer.change_scene(preload("res://scenes/playground.tscn"))




func _on_tutorial_button_pressed() -> void:
	TransitionLayer.change_scene(preload("res://scenes/tutorial_scene.tscn"))
