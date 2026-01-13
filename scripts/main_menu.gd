extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

@onready var settings = preload("res://scenes/settings_menu.tscn")
@onready var start = preload("res://scenes/main.tscn")

func _ready() -> void:
	play_button.button_down.connect(on_play_down)
	quit_button.button_down.connect(on_quit_down)
	settings_button.button_down.connect(on_settings_down)
	
func on_play_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func on_settings_down() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func on_quit_down() -> void:
	get_tree().quit()
	
