extends State

@export var idle: State
@export var sprint: State 

func Enter() -> void:
	
	pass

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:
	
	if owner.current_speed == owner.sprint_speed: 
		Transitioned.emit(self, sprint.name)

	if owner.velocity == Vector2.ZERO: 
		Transitioned.emit(self, idle.name)
