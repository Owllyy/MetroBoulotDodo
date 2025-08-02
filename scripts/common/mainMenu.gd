extends CanvasLayer

@onready var settings_popup = $SettingsMenu

func _on_settings_button_pressed() -> void:
	settings_popup.visible = true

func _on_close_settings_pressed() -> void:
	settings_popup.visible = false
