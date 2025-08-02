extends CharacterBody2D


@export var DASH_TIME : float = 10
@export var DASH_SPEED : float  = 10
@export var DASH_COST : int = 80
@export var BASE_SPEED : float = 500
@export var SPRINT_SPEED : float = 700.0
@export var BASE_STAMINA : int = 200
@export var FRICTION : float = 0.15
@export var ACCELERATION : float  = 0.2
@export var SPEED : int = 500
@export var DASH_LENGTH : float = 10
@export var BASE_LIFE: int = 100

var life : int = BASE_LIFE
var dashing : float = 0
var stamina : int = 200

func _physics_process(delta: float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("ui_accept") && dashing <= 0 && stamina > DASH_COST && direction:
		dashing = 1
		stamina -= DASH_COST
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
		if dashing > 0:
			velocity = velocity.lerp(direction.normalized() * SPEED * DASH_LENGTH, ACCELERATION * DASH_SPEED)
		else:
			velocity = velocity.lerp(direction.normalized() * SPEED, ACCELERATION)
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION)

	dashing -= delta * DASH_TIME
	move_and_slide()
	
func take_damage(damage: int):
	if life > damage:
		life -= damage
	else:
		death()
		
func death():
	print_debug("You died")
	
