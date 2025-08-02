extends CharacterBody2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	velocity = direction * speed
