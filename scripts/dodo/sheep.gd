extends CharacterBody2D

var moveSpeed = 5
var active: bool = true
var direction = Vector2(0, 0)
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	chooseDirection()

func chooseDirection():
	direction = Vector2(randf_range(0.01, 1.0), randf_range(0.01, 1.0))
	direction = direction.normalized()

func _process(delta: float) -> void:
	var collision = move_and_collide(direction * moveSpeed * delta);
	if collision:
		onCollision(collision)

func onCollision(collision: KinematicCollision2D):
	direction = direction.bounce(collision.get_normal())
