extends Node2D

@onready var label : Label = $Label

func _ready() -> void:
	label.text = "Day " + str(GameManager.getDayCount())
	
	var tween = create_tween()
	var tcallback = tween.tween_callback(_animation_finished)

	if GameManager.getDayCount() == 1:
		tcallback.set_delay(3)
	else:
		tcallback.set_delay(2)

func _animation_finished():
	GameManager.startCurrentStage()
