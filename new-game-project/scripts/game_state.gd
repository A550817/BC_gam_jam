extends Node

var player_textures = {}
var winner_id : int = -1

func register_player(player_id: int, texture: Texture2D):
	player_textures[player_id] = texture

func set_winner(dead_player_id: int):
	if dead_player_id == 1:
		winner_id = 2
	else:
		winner_id = 1

func get_winner_texture():
	return player_textures.get(winner_id, null)

func reset():
	winner_id = -1
	player_textures.clear()
