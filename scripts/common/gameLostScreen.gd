extends CanvasLayer

@onready var settings_popup = $SettingsMenu

func _on_play_pressed() -> void:
	GameManager.goToNextStage()

func _on_settings_button_pressed() -> void:
	settings_popup.visible = true

func _settings_menu_on_close_request() -> void:
	settings_popup.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
