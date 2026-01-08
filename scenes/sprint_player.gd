extends State

@export var idle: State
@export var move_speed : float = 100.0
@export var health_drain : float = 2.0

func Enter() -> void:
	owner.move_speed = move_speed
	owner.health_drain = health_drain

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:

	if not Input.is_action_pressed("Sprint"): 
			Transitioned.emit(self, idle.name)
