extends Node2D

const shoe_white_texture = preload("res://assets/boulot/shoe_white.png")
const shoe_black_texture = preload("res://assets/boulot/shoe_black.png")
const SHOE_SCENE = preload("res://scenes/boulot/shoe.tscn")

@onready var spawn_area = $shoe_spawn_area/area
@onready var spawn_timer = $SpawnTimer
@onready var boulot = $".."

var shoe_speed = 100.0

func _ready():
	spawn_timer.start()
	
func start_spawner():
	spawn_timer.start()

func _on_timer_timeout() -> void:
	var color = randi() & 1
	spawn_shoe(color)
	
func spawn_shoe(color):
	var shoe_instance = SHOE_SCENE.instantiate()
	
	# Générer une position aléatoire dans la zone de spawn
	var rect = spawn_area.shape.get_rect()
	var x = randf_range(rect.position.x, rect.end.x)
	var y = randf_range(rect.position.y, rect.end.y)
	shoe_instance.position = spawn_area.global_position + Vector2(x, y)
	
	# Assigner une vitesse
	shoe_instance.set_meta("velocity", Vector2(shoe_speed, 0))
	
	# Éviter les collisions entre shoes
	shoe_instance.collision_layer = 2
	shoe_instance.collision_mask = 1
	add_child(shoe_instance)
	if color == 0:
		shoe_instance.sprite.texture = shoe_white_texture
	else:
		shoe_instance.sprite.texture = shoe_black_texture
	shoe_instance.shoe_color = color

func _process(delta):
	for shoe in get_tree().get_nodes_in_group("shoes"):
		var velocity = shoe.get_meta("velocity", Vector2.ZERO)
		shoe.position += velocity * delta

func _on_shoe_despawn_body_entered(body: Node2D) -> void:
	if body.is_in_group("shoes") :
		body.queue_free()

# 0 = white, 1 = black
func _on_box_black_body_entered(body: Node2D) -> void:
	if body.is_in_group("shoes") :
		if body.shoe_color == 1:
			boulot.update_score()
		body.queue_free()

func _on_box_white_body_entered(body: Node2D) -> void:
	if body.is_in_group("shoes") :
		if body.shoe_color == 0:
			boulot.update_score()
		body.queue_free()
