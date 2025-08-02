extends StaticBody2D

@onready var polygon2d = $Polygon2D2
@onready var collisionPolygon2d = $CollisionPolygon2D

func _ready():
	collisionPolygon2d.polygon = polygon2d.polygon
