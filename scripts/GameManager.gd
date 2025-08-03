extends Node

@export var stagesPerDay : Array[PackedScene] = []

var currentDay := 1
var currentStage := 0

# start at 1
func getDayCount() -> float:
	return currentDay

func goToNextStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	currentStage += 1
	if currentStage % stagesPerDay.size() == 0:
		currentDay += 1
		currentStage = 0
	
	startCurrentDay()

func startCurrentDay():
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])

func dbg_setDayCount(dayCount: int):
	currentDay = dayCount
