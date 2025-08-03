extends Node2D

@onready var trigame = $MiniGameTri
@onready var player = $CharacterBody2D

@onready var darkness = $Camera2D/DarkOverlay/dark

@onready var score_text = $Camera2D/UI/Score
@onready var light_timer = $LightTimer

const color_dark = Color(0,0,0,0.5)
const color_bright = Color(0,0,0,0)

var difficulty = 0
var current_shoes : int = 0
var quota : int = 5

func _ready() -> void:
	update_score_display()
	darkness.color = color_bright
	light_timer.start()
	trigame.hide()
	
func _process(delta: float) -> void:
	if darkness.color == color_dark:
		Globals.is_dark = true
	else :
		Globals.is_dark = false

func set_difficulty(difficulty : int):
	#on regarde le jour et on set
	pass
	
func switch_light():
	if darkness.color == color_bright:
		darkness.color = color_dark
	else:
		darkness.color = color_bright

func _openclose_minigame(name : String):
	if name == "trizone":
		if trigame.is_visible_in_tree():
			player.can_move = true
			trigame.hide()
		else:
			player.can_move = false
			trigame.show()
			trigame.start_spawner()
	
func update_score():
	current_shoes += 1
	update_score_display()
	if current_shoes >= quota:
		GameManager.goToNextStage()
	
func update_score_display():
	score_text.text = str(current_shoes) + " / " + str(quota)
	
func _on_light_timer_timeout() -> void:
	var onoff = randi() & 1
	if onoff == 1 :
		switch_light()
