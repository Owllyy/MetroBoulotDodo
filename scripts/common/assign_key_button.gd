extends Button

@export var action : String

var is_listening := false

func _ready():
	toggle_mode = true
	set_process_unhandled_input(false)
	focus_exited.connect(_on_focus_exited)
	pressed.connect(_on_button_pressed)
	update_button_text()

func _on_focus_exited():
	stop_listening()

func _on_button_pressed():
	if not is_listening:
		is_listening = true
		text = "Press a key..."
		set_pressed_no_signal(true)
		set_process_unhandled_input(true)
	else:
		stop_listening()

func _unhandled_input(event: InputEvent):
	if is_listening and event is InputEventKey and event.is_pressed() and not event.is_echo():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		stop_listening()

func update_button_text():
	var events = InputMap.action_get_events(action)
	if events.size() > 0 and events[0] is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(events[0].physical_keycode)
		text = OS.get_keycode_string(keycode)
	else:
		text = "No key assigned"

func stop_listening():
	is_listening = false
	set_pressed_no_signal(false)
	update_button_text()
	release_focus()
	set_process_unhandled_input(false)
