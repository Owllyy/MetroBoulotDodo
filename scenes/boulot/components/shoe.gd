extends RigidBody2D

@onready var sprite = $Sprite

var draggable = false
var is_inside_drop = false

# color 0 = white, 1 = black
var color : int = 0

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_pressed("left_click"):
			sleeping = true
			global_position = get_global_mouse_position()
		if Input.is_action_just_released("left_click"):
			sleeping = false
			pass
			
func _on_mouse_entered() -> void:
	draggable = true
	#scale = Vector2(2,2)

func _on_mouse_exited() -> void:
	draggable = false
	#scale = Vector2(1,1)
