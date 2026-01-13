extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var button: Button = $HBoxContainer/Button

@export var action_name: String = "Un-asigned"

var waiting_for_input := false


func _ready() -> void:
	button.pressed.connect(on_button_down)
	set_process_unhandled_key_input(false)

	set_action_name()
	set_text_for_key()


func set_action_name() -> void:
	label.text = action_name.replace("_", " ").to_pascal_case()


func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)

	if action_events.is_empty():
		button.text = "Unbound"
		return

	var event = action_events[0]

	if event is InputEventKey:
		button.text = OS.get_keycode_string(event.physical_keycode)
	else:
		button.text = "Unknown"


func on_button_down() -> void:
	button.text = "Press any key..."
	waiting_for_input = true
	set_process_unhandled_key_input(true)


func _unhandled_key_input(event: InputEvent) -> void:
	if not waiting_for_input:
		return

	if event is InputEventKey and event.pressed:
		rebind_action(event)
		waiting_for_input = false
		set_process_unhandled_key_input(false)


func rebind_action(event: InputEventKey) -> void:
	InputMap.action_erase_events(action_name)

	var new_event := InputEventKey.new()
	new_event.physical_keycode = event.physical_keycode
	InputMap.action_add_event(action_name, new_event)

	button.text = OS.get_keycode_string(event.physical_keycode)
