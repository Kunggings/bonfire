extends Control
@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton

@onready var start = preload("res://scenes/main.tscn")


func _ready() -> void:
	play_button.button_down.connect(on_play_down)
	quit_button.button_down.connect(on_quit_down)
	

func on_play_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func on_quit_down() -> void:
	get_tree().quit()
