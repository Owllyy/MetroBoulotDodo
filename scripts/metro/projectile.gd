extends CharacterBody2D
class_name Projectile

@export var sprite: AnimatedSprite2D
@export var speed: float = 200.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	velocity = direction * speed
	if direction.x > 0:
		sprite.play("walk_left")
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.play("walk_left")
		sprite.flip_h = false
	if direction.y > 0:
		sprite.play("walk_front")
	if direction.y < 0:
		sprite.play("walk_back")
	if direction.y == 0 && direction.x == 0:
		sprite.play("idle")

func _physics_process(_delta: float) -> void:
	move_and_slide()
