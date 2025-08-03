extends CharacterBody2D

@onready var mouseSprite = $Sprite2D
@export var line: Line2D
@export var maxPoints: int
@export var distanceBetweenPoints: int
@export var hitSound : AudioStream

@onready var visualPolygon = Polygon2D.new()
@onready var detectionArea = Area2D.new()
@onready var collisionPolygon = CollisionPolygon2D.new()

func _process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_pressed("interact"):
		mouseSprite.modulate = Color.BLACK
		addPointsToLine()
		checkSheepCollisionWithTrail()
	else:
		mouseSprite.modulate = Color.WHITE
		line.clear_points()

func addPointsToLine():
	if line.points.size() == 0:
		line.add_point(self.position)
		return
	
	var lastPoint = line.points[-1]
	
	while lastPoint.distance_to(self.position) > distanceBetweenPoints:
		if line.points.size() >= maxPoints:
			line.remove_point(0)
		
		var newPoint = lastPoint.move_toward(self.position, distanceBetweenPoints)
		line.add_point(newPoint)
		
		var closedLoop : PackedVector2Array = isClosedLoop(line.points)
		if (closedLoop.size() > 0):
			createLoop(closedLoop)
			line.clear_points()
			line.add_point(self.position)
			break
		
		lastPoint = newPoint

func checkSheepCollisionWithTrail(threshold: float = 5.0):
	var sheep_nodes = get_tree().get_nodes_in_group("sheep")
	
	for sheep in sheep_nodes:
		if !is_instance_valid(sheep):
			continue
		
		var index = is_sheep_touching_trail(sheep)
		if index > 0:
			line.points = line.points.slice(index)
			GameManager.playSFX(hitSound)

func is_sheep_touching_trail(sheep_node) -> int:
	var sheep_collision = null
	for child in sheep_node.get_children():
		if child is CollisionShape2D:
			sheep_collision = child
			break
	
	if !sheep_collision:
		return false
	
	# Check each line segment against the sheep's collision shape
	for i in range(0, line.points.size() - 1):
		var point_a = line.points[i]
		var point_b = line.points[i + 1]
		
		# Create a segment and test collision
		var segment_shape = SegmentShape2D.new()
		segment_shape.a = point_a
		segment_shape.b = point_b
		
		# Use Godot's collision detection
		if sheep_collision.shape.collide_and_get_contacts(
			sheep_node.global_transform,
			segment_shape,
			Transform2D.IDENTITY
		).size() > 0:
			return i + 1
	
	return false

func createLoop(points: PackedVector2Array):
	var polygon_loop = PolygonLoop.new(points)
	get_parent().add_child(polygon_loop)

func isClosedLoop(points: PackedVector2Array) -> PackedVector2Array:
	if points.size() < 4:
		return []
	
	# Check if last segment intersects with any non-adjacent segment
	var last_point = points[points.size() - 2]
	var current_point = points[points.size() - 1]
	
	for i in range(0, points.size() - 3):
		var result = Geometry2D.segment_intersects_segment(
			last_point, current_point,
			points[i], points[i + 1]
		)
		if result:
			return points.slice(i, points.size() - 1)
	
	return []
