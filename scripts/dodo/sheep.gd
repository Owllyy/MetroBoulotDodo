extends CharacterBody2D

@export var moveSpeed = 5
var active: bool = true
var direction = Vector2(0, 0)
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	chooseDirection()

func chooseDirection():
	direction = Vector2(randfn(0.0, 1.0), randfn(0.0, 1.0))
	direction.normalized()

func _process(delta: float) -> void:
	move_and_collide(direction * moveSpeed * delta);
