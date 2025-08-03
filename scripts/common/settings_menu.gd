extends Control

signal onCloseRequest

func _init() -> void:
	visible = false

func _ready() -> void:
	$SettingsPopup/MarginContainer/ScrollContainer/MarginContainer/Panel/Music/MusicValue.value = Globals.music_volume
	$SettingsPopup/MarginContainer/ScrollContainer/MarginContainer/Panel/Effects/EffectsValue.value = Globals.sfx_volume

func _on_music_value_value_changed(value: float) -> void:
	GameManager.setMusicVolume(value)

func _on_effects_value_value_changed(value: float) -> void:
	GameManager.setSFXVolume(value)

func _on_close_settings_pressed() -> void:
	onCloseRequest.emit()
