extends Node

@export var stagesPerDay : Array[PackedScene] = []
@export var gameLostTextures : Array[Texture2D] = []

var isStarted := false
var currentDay := 1
var currentStage := 0

func _ready() -> void:
	assert(stagesPerDay.size() == gameLostTextures.size(), "Must have one game lost texture per stage")

# start at 1
func getDayCount() -> float:
	return currentDay

func goToNextStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	if isStarted:
		currentStage += 1
		if currentStage % stagesPerDay.size() == 0:
			currentDay += 1
			currentStage = 0
	else:
		isStarted = true
	
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])

func dbg_setDayCount(dayCount: int):
	currentDay = dayCount
