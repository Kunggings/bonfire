extends State

@export var move: State
@export var move_speed : float = 0.0
@export var health_drain : float = 0.5

func Enter() -> void:
	owner.move_speed = move_speed
	owner.health_drain = health_drain

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:

	if owner.direction != Vector2.ZERO:
		Transitioned.emit(self, move.name)
		
