extends CanvasLayer


func _ready():
	var texture = GameState.get_winner_texture()
	var player_id = GameState.winner_id

	if texture:
		$Sprite2D.texture = texture

	if player_id == 1:
		$Label.text = "Player 2 Wins!"
	elif player_id == 2:
		$Label.text = "Player 1 Wins!"

	GameState.reset()


func _on_restart_button_pressed() -> void:
	TransitionLayer.change_scene(load("res://scenes/playground.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_home_button_pressed() -> void:
	TransitionLayer.change_scene(load("res://scenes/StartScreen.tscn"))
