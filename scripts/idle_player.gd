extends State

@export var move: State

func Enter() -> void:
	
	pass

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:

	if owner.velocity.length() > 0.1:
		Transitioned.emit(self, move.name)
