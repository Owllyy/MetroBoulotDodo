extends Node2D

@export var projectile_scene: PackedScene
@export var count: int = 12
@export var radius: float = 200.0
@export var speed: float = 300.0
@export var cd: float = 10.0
@export var active: bool = false


@onready var timer: Timer = $Timer

func set_cd(value):
	cd = value
	timer.wait_time = cd

func set_active():
	timer.timeout.connect(spawn_projectiles)
	timer.wait_time = cd

func spawn_projectiles() -> void:
	if not projectile_scene:
		return

	var random_angle = randf_range(0, TAU)
	var spawn_position = Vector2(radius, 0).rotated(random_angle)
	var projectile = projectile_scene.instantiate()
	var direction_to_center = -spawn_position.normalized()
	projectile.global_position = global_position + spawn_position
	projectile.direction = direction_to_center
	
	var angle_variation_degrees = 25.0
	var random_angle_rad = deg_to_rad(randf_range(-angle_variation_degrees, angle_variation_degrees))
	var final_direction = direction_to_center.rotated(random_angle_rad)
	projectile.global_position = global_position + spawn_position
	projectile.direction = final_direction
	add_child(projectile)
