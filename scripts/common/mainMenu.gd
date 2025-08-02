extends CanvasLayer

@onready var settings_popup = $SettingsMenu

func _on_settings_button_pressed() -> void:
	settings_popup.visible = true
