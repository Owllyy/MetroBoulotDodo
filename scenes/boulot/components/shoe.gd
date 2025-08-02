extends RigidBody2D

@onready var sprite = $Sprite

var draggable = false
var is_inside_drop = false

# color 0 = white, 1 = black
var color : int = 0

func _process(delta: float) -> void:
	pass
	
func _on_mouse_entered() -> void:
	scale = Vector2(2,2)

func _on_mouse_exited() -> void:
	scale = Vector2(1,1)
