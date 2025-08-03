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
	
	add_child(projectile)
