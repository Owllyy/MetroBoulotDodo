extends Node2D

@onready var trigame = $MiniGameTri
@onready var player = $CharacterBody2D

var current_shoes = 0
var quota = 5

func _openclose_minigame(name : String):
	if name == "trizone":
		if trigame.is_visible_in_tree():
			player.can_move = true
			trigame.hide()
		else:
			player.can_move = false
			trigame.show()
			trigame.start_spawner()

func _ready() -> void:
	trigame.hide()
