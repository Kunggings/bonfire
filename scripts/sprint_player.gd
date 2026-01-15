extends State

@export var idle: State
@export var dash: State
@export var death:State
@export var move_speed : float = 100.0
@export var health_drain : float = 2.0
@onready var run_sound: AudioStreamPlayer2D = $"../../RunSound"

func Enter() -> void:
	owner.move_speed = move_speed
	owner.health_drain = health_drain
	run_sound.play()

func Exit() -> void:
	run_sound.stop()
	

func Physics_Update(_delta: float) -> void:

	owner.animation.play("Sprint")
	
	if not Input.is_action_pressed("Sprint") or owner.direction == Vector2.ZERO: 
			Transitioned.emit(self, idle.name)
	
	if Input.is_action_just_pressed("Dash") and owner.current_health >= 1.5 * dash.health_cost and owner.held_item == null:
		Transitioned.emit(self, dash.name)

	if owner.current_health <= 0.0:
			Transitioned.emit(self, death.name)	
