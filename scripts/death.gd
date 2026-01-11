extends State

@export var move: State
@export var move_speed : float = 0.0
@onready var death_timer: Timer = $DeathTimer
@export var death_duration: float = 3.0

func _ready():
	death_timer.timeout.connect(_on_death_timeout)

func Enter() -> void:
	owner.move_speed = move_speed
	owner.animation.play("Death")
	
	death_timer.wait_time = death_duration
	death_timer.start()
	

func _on_death_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
