extends Node

@export var music: AudioStream
@export var SheepScene : PackedScene = preload("res://scenes/dodo/sheep.tscn")
@onready var spawn_area = $SpawnArea
var random = RandomNumberGenerator.new()
var minSheepSpeed : int = 20
var game_timer: Timer
@onready var timerSlider: ProgressBar = $TimerBar

func _ready() -> void:
	random.randomize()
	
	start(GameManager.getDayCount())
	GameManager.playMusic(music)

func start(iteration: int):
	var sheepsToSpawn = iteration * 3
	var maxSheepSpeed = 15 + (10 * iteration)
	var maxSize = 1 + (0.1 * iteration)
	
	setupTimer(15.0 + (2 * iteration))
	spawnSheeps(sheepsToSpawn, maxSheepSpeed, maxSize)
	game_timer.start()

func setupTimer(timer_duration: float):
	game_timer = Timer.new()
	game_timer.wait_time = timer_duration
	timerSlider.max_value = timer_duration
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_timer_timeout)
	add_child(game_timer)

func spawnSheeps(sheepNumber: int, maxSheepSpeed: int, maxSize: float):
	for i in sheepNumber:
		var sheepRef = SheepScene.instantiate()
		sheepRef.moveSpeed = randf_range(minSheepSpeed, maxSheepSpeed)
		sheepRef.scale = Vector2(1.0, 1.0) *  randf_range(.9, maxSize)
		
		if spawn_area and spawn_area is Area2D:
			# Get the CollisionPolygon2D from the Area2D
			var collision_polygon = spawn_area.get_child(0) as CollisionPolygon2D
			
			if collision_polygon and collision_polygon.polygon.size() > 0:
				# Get a random point inside the polygon
				var polygon_points = collision_polygon.polygon
				var random_pos = get_random_point_in_polygon(polygon_points)
				sheepRef.position = spawn_area.global_position + random_pos
			else:
				# Fallback: spawn at spawn_area position
				sheepRef.position = spawn_area.global_position
		
		sheepRef.add_to_group("sheep")
		add_child(sheepRef)

func get_random_point_in_polygon(polygon: PackedVector2Array) -> Vector2:
	# Get bounding box of the polygon
	var min_x = polygon[0].x
	var max_x = polygon[0].x
	var min_y = polygon[0].y
	var max_y = polygon[0].y
	
	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	# Keep trying random points until we find one inside the polygon
	for attempt in range(100):  # Prevent infinite loop
		var random_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
		
		if Geometry2D.is_point_in_polygon(random_point, polygon):
			return random_point
	
	# Fallback: return center of bounding box
	return Vector2((min_x + max_x) / 2, (min_y + max_y) / 2)

func _process(delta: float) -> void:
	timerSlider.value = game_timer.time_left
	var alive_sheep = get_tree().get_nodes_in_group("sheep")
	if alive_sheep.size() == 0:
		game_timer.stop()
		GameManager.goToNextStage()

func _on_timer_timeout():
	gameFail()

func gameFail():
	GameManager.goToLooseScreen()
	print("Game Failed - Time's up!")
