extends Control


@onready var back_button: Button = $"Back Button"
@onready var start = preload("res://scenes/main_menu.tscn")

func _ready() -> void:
	back_button.button_down.connect(on_back_down)


func on_back_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
