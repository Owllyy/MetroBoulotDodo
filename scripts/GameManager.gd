extends Node

@export var stagesPerDay : Array[PackedScene] = []

var currentDay := 1
var currentStage := 0
var dbg_dontChangeStage := false
var dbg_dontChangeDay := false

func _ready():
	var currentScene = get_tree().current_scene
	for i in range(0, stagesPerDay.size()):
		if currentScene == stagesPerDay[i]:
			currentStage = i
			break

# start at 1
func getDayCount() -> float:
	return currentDay

func goToNextStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	if dbg_dontChangeStage:
		if not dbg_dontChangeDay:
			currentDay += 1

		startCurrentDay()
		return
	
	currentStage += 1
	if currentStage % stagesPerDay.size() == 0:
		if not dbg_dontChangeDay:
			currentDay += 1
		currentStage = 0
	
	startCurrentDay()

func startCurrentDay():
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])

func dbg_setDayCount(dayCount: int):
	currentDay = dayCount
