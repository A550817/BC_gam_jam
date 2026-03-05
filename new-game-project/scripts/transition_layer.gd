extends CanvasLayer

func change_scene(scene: PackedScene):
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_packed(scene)
	
	$AnimationPlayer.play("fade_out")
