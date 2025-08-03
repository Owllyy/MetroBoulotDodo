extends Node2D

@onready var trigame = $MiniGameTri
@onready var player = $CharacterBody2D

@onready var darkness = $DarkOverlay/dark

@onready var score_text = $Score

var is_dark : bool = false

var current_shoes : int = 0
var quota : int = 5

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
	
func update_score_display():
	score_text.text = str(current_shoes) + " / " + str(quota)
	
func _ready() -> void:
	update_score_display()
	trigame.hide()
