extends State
class_name FollowTest

@export var move_speed := 20.0
@export var lose_state: State 

@onready var detection_area: Area2D = $"../../DetectionArea"

func Enter() -> void:
	
	pass


func Exit() -> void:
	
	pass

func Physics_Update(_delta: float) -> void:	

	owner.target = owner.target_body.global_position
	
	if not owner.target_is_visible:
		Transitioned.emit(self, lose_state.name)
