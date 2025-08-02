extends Node

@export var arrow_left: Sprite2D
@export var arrow_right: Sprite2D
@export var stop: ColorRect
@export var character: CharacterBody2D

@onready var event_timer: Timer = $Timer

var force = Vector2.ZERO

func _on_timeout() -> void:
	do_event()

var event_list: PackedStringArray = []
var current_event_index = 0
func init_event_list():
	for index in range(10):
		var event_type = randi_range(0, 3);
		match event_type:
			0:
				event_list.push_back("left")
			1:
				event_list.push_back("right")
			2:
				event_list.push_back("stop")

func do_event():
	arrow_right.visible = false
	arrow_left.visible = false
	stop.visible = false
	if current_event_index == event_list.size() - 1:
		return
	match event_list[current_event_index]:
			"left":
				metro_right()
			"right":
				metro_left()
			"stop":
				metro_stop()
	current_event_index += 1;

func metro_right():
	arrow_right.visible = true
	force = Vector2(2000, 0)
	
func metro_left():
	arrow_left.visible = true
	force = Vector2(-2000, 0)
	
func metro_stop():
	stop.visible = true
	force = Vector2(0, 2000)

func _ready():
	init_event_list()
	event_timer = Timer.new()
	add_child(event_timer)
	event_timer.timeout.connect(do_event)
	event_timer.one_shot = false
	event_timer.start(3);
	
func _physics_process(delta: float) -> void:
	character.apply_force(force * delta)
