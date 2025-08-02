extends Node

@export var stagesPerDay : Array[PackedScene] = []

var currentDay = 0
var currentStage = 0

func goToNextStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	if currentDay == 0:
		++currentDay
	else:
		++currentStage
		if currentStage % stagesPerDay.size() == 0:
			++currentDay
			currentStage = 0
	
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])
