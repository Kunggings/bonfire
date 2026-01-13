extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton


func _ready() -> void:
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)

func add_resolution_items() -> void:
	option_button.clear()

	option_button.add_separator("16:9")
	_add_resolution("1280 x 720", Vector2i(1280, 720))
	_add_resolution("1366 x 768", Vector2i(1366, 768))
	_add_resolution("1600 x 900", Vector2i(1600, 900))
	_add_resolution("1920 x 1080", Vector2i(1920, 1080))
	_add_resolution("2560 x 1440", Vector2i(2560, 1440))
	_add_resolution("3840 x 2160", Vector2i(3840, 2160))

	option_button.add_separator("16:10")
	_add_resolution("1280 x 800", Vector2i(1280, 800))
	_add_resolution("1440 x 900", Vector2i(1440, 900))
	_add_resolution("1680 x 1050", Vector2i(1680, 1050))
	_add_resolution("1920 x 1200", Vector2i(1920, 1200))
	_add_resolution("2560 x 1600", Vector2i(2560, 1600))

	option_button.add_separator("4:3")
	_add_resolution("1024 x 768", Vector2i(1024, 768))
	_add_resolution("1280 x 960", Vector2i(1280, 960))
	_add_resolution("1600 x 1200", Vector2i(1600, 1200))

	option_button.add_separator("Ultrawide")
	_add_resolution("2560 x 1080", Vector2i(2560, 1080))
	_add_resolution("3440 x 1440", Vector2i(3440, 1440))


func _add_resolution(text: String, _size: Vector2i) -> void:
	option_button.add_item(text)
	var id := option_button.get_item_count() - 1
	option_button.set_item_metadata(id, size)


func on_resolution_selected(index: int) -> void:

	var new_size: Vector2i = option_button.get_item_metadata(index)

	DisplayServer.window_set_size(new_size)

	var screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(screen)
	var screen_pos := DisplayServer.screen_get_position(screen)

	var centered_position := screen_pos + (screen_size - new_size) / 2
	DisplayServer.window_set_position(centered_position)
