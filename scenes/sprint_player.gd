extends State

@export var idle: State

func Enter() -> void:
	
	pass

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:

	if owner.velocity == Vector2.ZERO: 
			Transitioned.emit(self, idle.name)
