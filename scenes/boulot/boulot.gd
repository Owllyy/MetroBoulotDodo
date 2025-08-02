extends Node2D

@onready var trigame = $MiniGameTri
@onready var player = $CharacterBody2D

func _open_minigame(name : String):
	pass

func _ready() -> void:
	trigame.hide()
