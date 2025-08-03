extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var hurt_sound : AudioStreamPlayer2D

@export var BASE_SPEED : float = 500
@export var SPRINT_SPEED : float = 700.0
@export var BASE_STAMINA : int = 200
@export var FRICTION : float = 0.15
@export var ACCELERATION : float  = 0.2
@export var SPEED : int = 500
@export var BASE_LIFE: int = 3

var life : int = BASE_LIFE
var stamina : int = 200

var can_move : bool = true

var external_force: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	if can_move:
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
		
		if direction.length() > 0:
			velocity = velocity.lerp(direction.normalized() * SPEED, ACCELERATION)
		else:
			velocity = velocity.lerp(Vector2.ZERO, FRICTION)
		
		velocity += external_force
		move_and_slide()
		external_force = Vector2.ZERO
	
func take_damage():
	hurt_sound.play()
	if life > 1:
		life -= 1
		return 0
	else:
		return 1
		
func death():
	print_debug("You died")

func apply_force(force: Vector2) -> void:
	external_force += force
	
var blink_tween: Tween
func start_blink_effect():
	if blink_tween:
		blink_tween.kill()

	blink_tween = create_tween().set_loops()
	var sprite = $Sprite2D 
	blink_tween.tween_property(sprite, "modulate:a", 0.2, 0.1)
	blink_tween.chain().tween_property(sprite, "modulate:a", 1.0, 0.1)

func stop_blink_effect():
	if blink_tween:
		blink_tween.kill()
		blink_tween = null
	
	var sprite = $Sprite2D
	sprite.modulate.a = 1.0
