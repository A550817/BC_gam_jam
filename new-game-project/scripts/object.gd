@tool
extends SoftBody2DRigidBody


@export var texture: CompressedTexture2D:
	set(value):
		texture = value
		$Sprite2D.texture = value



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
