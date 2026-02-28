extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 8.5
var noise = FastNoiseLite.new()
var noise_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise.frequency = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		noise_time += 50 * delta
		offset.x = noise.get_noise_2d(noise_time, 0) * shake_strength
		offset.y = noise.get_noise_2d(0, noise_time) * shake_strength
		
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	else:
		offset = Vector2.ZERO


func shake(amount: float):
	shake_strength = amount
