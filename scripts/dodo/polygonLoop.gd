class_name PolygonLoop
extends Node2D

var visualPolygon: Polygon2D
var detectionArea: Area2D
var collisionPolygon: CollisionPolygon2D

var loopSound: AudioStream = preload("res://assets/dodo/loop.wav")

var tween : Tween

func _init(points: PackedVector2Array):
	createPolygon(points)
	createDetectionArea(points)

func _ready():
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

func flashPolygon():
	if loopSound:
		GameManager.playSFXOnce(loopSound)

	tween = create_tween()
	tween.set_loops(2)
	tween.tween_property(visualPolygon, "modulate:a", 0.0, 0.05)
	tween.tween_property(visualPolygon, "modulate:a", 1.0, 0.05)
	
	tween.tween_callback(hideAndCleanupVisuals).set_delay(0.1)


func _on_body_entered(body):
	if body.is_in_group("sheep"):
		body.catch()
		#body.queue_free()

func hideAndCleanupVisuals():
	# Immediately hide/remove visual and collision components
	if detectionArea:
		detectionArea.queue_free()
	if visualPolygon:
		tween.stop()
		visualPolygon.queue_free()
	
	queue_free() 
