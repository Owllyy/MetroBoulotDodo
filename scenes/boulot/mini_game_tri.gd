extends Node2D

var speed_tapis : float = 1.0

const shoe_white_texture = preload("res://assets/boulot/shoe_white.png")
const shoe_black_texture = preload("res://assets/boulot/shoe_black.png")
const shoe_scene: PackedScene = preload("res://scenes/boulot/components/shoe.tscn")
@onready var shoe_spawn_area = $shoe_spawn_area/area
@onready var shoe_spawn_timer = $Timer

func spawn_shoe(color : int):
	var new_shoe = shoe_scene.instantiate()
	new_shoe.color = color
	add_child(new_shoe)
	if new_shoe.color == 0:
		new_shoe.sprite.texture = shoe_white_texture
	else:
		new_shoe.sprite.texture = shoe_black_texture
	new_shoe.position.x = -700
	new_shoe.position.y = randi_range(50, -200)
	new_shoe.linear_velocity = Vector2(100.0,0.0)
	
func start_spawner():
	shoe_spawn_timer.start()
	
func _on_timer_timeout() -> void:
	var color = randi() & 1
	var rect : Rect2 = shoe_spawn_area.shape.get_rect()
	var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
	var rand_point = Vector2(x,y)
	spawn_shoe(color)
