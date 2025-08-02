extends CharacterBody2D

@export var BASE_SPEED : float = 500
@export var SPRINT_SPEED : float = 700.0
@export var BASE_STAMINA : int = 200
@export var FRICTION : float = 0.15
@export var ACCELERATION : float  = 0.2
@export var SPEED : int = 500
@export var BASE_LIFE: int = 3

var life : int = BASE_LIFE
var stamina : int = 200

var external_force: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var sprint_pressed = false
	SPEED = BASE_SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		sprint_pressed = true
	if sprint_pressed && direction.length() && stamina > 0:
		SPEED += SPRINT_SPEED
		stamina -= 1
	elif !sprint_pressed && stamina < BASE_STAMINA:
		stamina += 1
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * SPEED, ACCELERATION)
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION)
	
	velocity += external_force
	move_and_slide()
	external_force = Vector2.ZERO
	
func take_damage():
	if life > 1:
		life -= 1
	else:
		death()
		
func death():
	print_debug("You died")

func apply_force(force: Vector2) -> void:
	external_force += force
