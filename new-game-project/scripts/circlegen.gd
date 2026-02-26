extends RigidBody2D

@onready var poly = $Polygon2D
@onready var col = $CollisionPolygon2D

func _ready():
	var radius = 80.0
	var points = 24
	var polygon = PackedVector2Array()
	
	for i in points:
		var angle = TAU * i / points
		var p = Vector2(cos(angle), sin(angle)) * radius
		polygon.append(p)
	
	poly.polygon = polygon
	col.polygon = polygon
