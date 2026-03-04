@tool
extends SoftBody2DRigidBody

@export var w : float = 512
@export var h: float = 512
@export var fixed : bool = false

@export var texture: CompressedTexture2D:
	set(value):
		texture = value
		$NinePatchRect.texture = value

func scale_children(size: float):
	w*=size
	h*=size
	$NinePatchRect.size = Vector2(w, h)
	$NinePatchRect.position = Vector2(-w/2, -h/2)
	$CollisionShape2D.scale = Vector2(w/512, h/512)
	mass = (w/512) * (h/512)

func _ready() -> void:
	freeze = fixed
	scale_children(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
