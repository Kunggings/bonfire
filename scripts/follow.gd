extends State

@export var move_speed := 20.0
@export var lose_state: State 
@export var attack_state: State
@onready var attack: Node = $"../Attack"

func Enter() -> void:
	
	pass


func Exit() -> void:
	
	pass

func Physics_Update(_delta: float) -> void:	

	owner.animate.play("Walk")

	owner.target = owner.target_body.global_position
	
	if owner.global_position.distance_to(owner.target_body.global_position) < attack.attack_range:
		Transitioned.emit(self, attack_state.name)
	
	if not owner.target_is_visible:
		Transitioned.emit(self, lose_state.name)
	
	
