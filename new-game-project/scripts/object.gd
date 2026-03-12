@tool
extends SoftBody2DRigidBody

@export var w : float = 512
@export var h: float = 512
@export var fixed : bool = false

@export var texture: CompressedTexture2D:
	set(value):
		texture = value
		$NinePatchRect.texture = value

func scale_children(size: float, visual_size: float):
	if (w+size >= 40 && h+size >= 40):
		w+=size
		h+=size
		if size==0:
			$CollisionShape2D.scale = Vector2(w/512, h/512)
		mass = (w/512) * (h/512) + 1
	var visw = w-10+visual_size
	var vish = h-10+visual_size
	$NinePatchRect.size = Vector2(visw, vish)
	$NinePatchRect.position = Vector2(-visw/2, -vish/2)

func _ready() -> void:
	freeze = fixed
	scale_children(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
