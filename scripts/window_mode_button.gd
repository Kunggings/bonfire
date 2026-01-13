extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

enum WindowMode {
	FULLSCREEN,
	WINDOWED,
	BORDERLESS_WINDOW,
	BORDERLESS_FULLSCREEN
}


func _ready() -> void:
	option_button.clear()
	option_button.add_item("Full-Screen", WindowMode.FULLSCREEN)
	option_button.add_item("Window Mode", WindowMode.WINDOWED)
	option_button.add_item("Borderless Window", WindowMode.BORDERLESS_WINDOW)
	option_button.add_item("Borderless FullScreen", WindowMode.BORDERLESS_FULLSCREEN)

	option_button.item_selected.connect(on_window_mode_selected)


func on_window_mode_selected(index: int) -> void:
	match index:
		WindowMode.FULLSCREEN:
			DisplayServer.window_set_flag(
				DisplayServer.WINDOW_FLAG_BORDERLESS,
				false
			)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		WindowMode.WINDOWED:
			DisplayServer.window_set_flag(
				DisplayServer.WINDOW_FLAG_BORDERLESS,
				false
			)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

		WindowMode.BORDERLESS_WINDOW:
			DisplayServer.window_set_flag(
				DisplayServer.WINDOW_FLAG_BORDERLESS,
				true
			)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

		WindowMode.BORDERLESS_FULLSCREEN:
			DisplayServer.window_set_flag(
				DisplayServer.WINDOW_FLAG_BORDERLESS,
				true
			)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
