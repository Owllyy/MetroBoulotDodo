class_name PolygonLoop
extends Node2D

var visualPolygon: Polygon2D
var detectionArea: Area2D
var collisionPolygon: CollisionPolygon2D

func _init(points: PackedVector2Array):
	createPolygon(points)
	createDetectionArea(points)
	flashPolygon()

func createPolygon(points: PackedVector2Array):
	visualPolygon = Polygon2D.new()
	visualPolygon.polygon = points
	visualPolygon.antialiased = true
	visualPolygon.color = Color(1, 1, 0, 0.5)
	visualPolygon.z_index = 100
	add_child(visualPolygon)

func createDetectionArea(points: PackedVector2Array):
	detectionArea = Area2D.new()
	collisionPolygon = CollisionPolygon2D.new()
	collisionPolygon.polygon = points
	
	detectionArea.add_child(collisionPolygon)
	add_child(detectionArea)
	
	detectionArea.body_entered.connect(_on_body_entered)
	detectionArea.area_entered.connect(_on_area_entered)

func flashPolygon():
	var tween = create_tween()
	tween.set_loops(4)  # Flash a few times
	tween.tween_property(visualPolygon, "modulate:a", 0.0, 0.125)
	tween.tween_property(visualPolygon, "modulate:a", 1.0, 0.125)
	
	tween.tween_callback(cleanupPolygon).set_delay(0.5)

func _on_body_entered(body):
	print("Body inside polygon: ", body.name)

func _on_area_entered(area):
	print("Area inside polygon: ", area.name)

func cleanupPolygon():
	queue_free()  # This removes the entire PolygonLoop node
