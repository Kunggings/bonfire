extends State

@export var move_speed := 20.0
@export var arrived_state: State
@export var follow_state: State

var wander_location : Vector2

func Enter() -> void:
	owner.target = owner.target_body.global_position


func Physics_Update(_delta: float) -> void:
	
	owner.animate.play("Walk")
	
	if owner.target.distance_to(owner.global_position) <= 20 :
		Transitioned.emit(self, arrived_state.name)
	
	if owner.target_is_visible == true:
		Transitioned.emit(self, follow_state.name)
