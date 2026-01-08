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

	var to_target : Vector2 = owner.target.global_position - owner.global_position
	owner.velocity = to_target.normalized() * move_speed
	
	if not owner.target_is_visible:
		Transitioned.emit(self, lose_state.name)
