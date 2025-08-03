extends Node

@export var stagesPerDay : Array[PackedScene] = []
@export var stageLostScreen : PackedScene
@export var stageLostTextures : Array[Texture2D] = []
@export var gameLostScreen : PackedScene
@export var nextDayScreen : PackedScene

var isStarted := false
var currentDay := 1
var currentStage := 0
var lifes = 3

func _ready() -> void:
	assert(stagesPerDay.size() == stageLostTextures.size(), "Must have one game lost texture per stage")
	
	for i in range(0, stagesPerDay.size()):
		print(stagesPerDay[i].resource_path + " " + get_tree().current_scene.scene_file_path)
		if stagesPerDay[i].resource_path == get_tree().current_scene.scene_file_path:
			isStarted = true
			currentStage = i
			break

# start at 1
func getDayCount() -> int:
	return currentDay

func goToLooseScreen():
	assert(isStarted)
	assert(stageLostScreen != null)
	
	lifes -= 1
	if lifes > 0:
		get_tree().change_scene_to_packed(stageLostScreen)
	else:
		get_tree().change_scene_to_packed(gameLostScreen)

func goToNextStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	if isStarted:
		currentStage += 1
		if currentStage % stagesPerDay.size() == 0:
			currentDay += 1
			currentStage = 0
			get_tree().change_scene_to_packed(nextDayScreen)
			return
	else:
		isStarted = true
		get_tree().change_scene_to_packed(nextDayScreen)
		return
	
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])

func startCurrentStage():
	assert(!stagesPerDay.is_empty(), "Must have at least one stage per day")
	
	get_tree().change_scene_to_packed(stagesPerDay[currentStage])

func dbg_setDayCount(dayCount: int):
	currentDay = dayCount

func getCurrentGameLostTexture() -> Texture2D:
	return stageLostTextures[currentStage]

func playMusic(stream: AudioStream):
	$MusicPlayer.stream = stream
	$MusicPlayer.play()

func playSFX(stream: AudioStream):
	if not $SFXPlayer.playing:
		$SFXPlayer.stream = stream
		$SFXPlayer.play()

func playSFXOnce(stream: AudioStream, volume: float = 1.0) -> AudioStreamPlayer2D:
	var player = AudioStreamPlayer2D.new()
	player.volume_db = linear_to_db(max(0, Globals.sfx_volume * volume))
	player.stream = stream
	add_child(player)
	player.finished.connect(_on_player_finished.bind(player))
	player.play()
	return player

func setMusicVolume(volume: float):
	Globals.music_volume = volume
	$MusicPlayer.volume_db = linear_to_db(volume)

func setSFXVolume(volume: float):
	Globals.sfx_volume = volume
	$SFXPlayer.volume_db = linear_to_db(volume)

func _on_player_finished(player: AudioStreamPlayer2D) -> void:
	player.queue_free()
