extends CharacterBody2D

@onready var mouseSprite = $Sprite2D
@export var line: Line2D
@export var maxPoints: int
@export var distanceBetweenPoints: int

@onready var visualPolygon = Polygon2D.new()
@onready var detectionArea = Area2D.new()
@onready var collisionPolygon = CollisionPolygon2D.new()

func _process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouseSprite.modulate = Color.BLACK
		addPointsToLine()
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
			print("Loop detected")
			createLoop(closedLoop)
			line.clear_points()
			line.add_point(self.position)
			break
		
		lastPoint = newPoint

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
