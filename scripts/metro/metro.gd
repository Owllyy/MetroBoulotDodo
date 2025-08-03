extends Node

var difficulty = 1

@export var wagon: AnimatedSprite2D
@export var TILT_ANGLE: float = 7.0
@export var camera: Camera2D
@export var CAMERA_OFFSET: float = 60.0

@export var ding: AudioStreamPlayer2D
@export var door_open: AudioStreamPlayer2D
@export var door_close: AudioStreamPlayer2D

@export var arrow_left: AnimatedSprite2D
@export var arrow_right: AnimatedSprite2D
@export var arrow_down: AnimatedSprite2D
@export var arrow_up: AnimatedSprite2D
@export var character: CharacterBody2D

@onready var event_timer: Timer = $Timer
var EVENT_RYTHM: float = 7.0
@export var EVENT_DURATION: float = 3.0
@export var EVENT_PREPARE_DURATION: float = 1.5

var help = false

@export var PUSH_FORCE_MIN = 2000
@export var PUSH_FORCE_MAX = 4000
@export var ACCELERATION_DURATION: float = EVENT_DURATION * 0.8
@export var DECELERATION_DURATION: float = EVENT_DURATION * 0.2
var force = Vector2.ZERO
var push_back = Vector2.ZERO
var current_tween: Tween

@export var INVINCIBILITY_DURATION = 1.0
var immunity = false

func _on_timeout() -> void:
	do_event()

var event_list: PackedStringArray = []
var current_event_index = 0
func init_event_list():
	for index in range(10):
		var event_type = randi_range(0, 2);
		match event_type:
			0: event_list.push_back("left")
			1: event_list.push_back("right")
			2: 
				event_list.push_back("stop")
				event_list.push_back("start")

func do_event():
	if current_event_index == event_list.size() - 1:
		return
	match event_list[current_event_index]:
			"left": metro_right()
			"right": metro_left()
			"stop": metro_stop()
			"start": metro_start()
	current_event_index += 1;

func metro_right():
	if help:
		arrow_right.visible = true
		arrow_right.play("default")
	await get_tree().create_timer(EVENT_PREPARE_DURATION).timeout
	start_force_tween(Vector2.LEFT)
	await get_tree().create_timer(EVENT_DURATION).timeout
	arrow_right.visible = false
	
func metro_left():
	if help:
		arrow_left.visible = true
		arrow_left.play("default")
	await get_tree().create_timer(EVENT_PREPARE_DURATION).timeout
	start_force_tween(Vector2.RIGHT)
	await get_tree().create_timer(EVENT_DURATION).timeout
	arrow_left.visible = false
	
func metro_stop():
	if help:
		arrow_down.visible = true
		arrow_down.play("default")
	ding.play()
	await get_tree().create_timer(EVENT_PREPARE_DURATION).timeout
	start_force_tween(Vector2.UP)
	await get_tree().create_timer(EVENT_DURATION).timeout
	arrow_down.visible = false
	door_open.play()
	await get_tree().create_timer(1.0).timeout
	wagon.play("open")

func metro_start():
	if help:
		arrow_up.visible = true
		arrow_up.play("default")
	event_timer.paused = true
	await get_tree().create_timer(2.0).timeout
	event_timer.paused = false
	door_close.play()
	wagon.play("close")
	await get_tree().create_timer(EVENT_PREPARE_DURATION).timeout
	start_force_tween(Vector2.DOWN)
	await get_tree().create_timer(EVENT_DURATION).timeout
	arrow_up.visible = false

func _ready():
	init_event_list()
	event_timer = Timer.new()
	wagon.play("default")
	add_child(event_timer)
	event_timer.timeout.connect(do_event)
	event_timer.one_shot = false
	event_timer.start(EVENT_RYTHM);
	EVENT_RYTHM -= (difficulty * 0.5)
	if difficulty < 2:
		help = true

func _physics_process(delta: float) -> void:
	character.apply_force(force * delta)
	character.apply_force(push_back * delta)

func start_force_tween(direction: Vector2):
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	var target_force = direction.normalized() * PUSH_FORCE_MAX
	var target_rotation = -direction.x * TILT_ANGLE
	var target_camera_offset = -direction.normalized() * CAMERA_OFFSET
	
	current_tween.tween_property(
		self,
		"force",
		target_force,
		ACCELERATION_DURATION
	).set_trans(Tween.TRANS_SINE)
	current_tween.parallel().tween_property(
	camera, "rotation_degrees", target_rotation, ACCELERATION_DURATION
	).set_trans(Tween.TRANS_SINE)
	current_tween.parallel().tween_property(camera, "offset", target_camera_offset, ACCELERATION_DURATION).set_trans(Tween.TRANS_SINE)
	current_tween.chain().tween_property(
		self, "force", Vector2.ZERO, DECELERATION_DURATION
	).set_trans(Tween.TRANS_SINE)
	current_tween.parallel().tween_property(
		camera, "rotation_degrees", 0.0, DECELERATION_DURATION
	).set_trans(Tween.TRANS_SINE)
	current_tween.parallel().tween_property(camera, "offset", Vector2.ZERO, DECELERATION_DURATION).set_trans(Tween.TRANS_SINE)



func _on_game_space_body_exited(body: Node2D) -> void:
	if immunity == false:
		if character.take_damage() == 1:
			GameManager.goToLooseScreen()
		else:
			character.start_blink_effect()
			immunity = true
			await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
			character.stop_blink_effect()
			immunity = false
