extends State

@export var move_speed := 20.0
@export var lose_state: State 
@export var attack_state: State
@onready var attack: Node = $"../Attack"
@onready var walk_sound: AudioStreamPlayer2D = $"../../WalkSound"

func Enter() -> void:
	walk_sound.play()



func Exit() -> void:
	walk_sound.stop()

func Physics_Update(_delta: float) -> void:	

	owner.animation.play("Walk")

	owner.target = owner.target_body.global_position
	
	if owner.global_position.distance_to(owner.target_body.global_position) < attack.attack_range:
		Transitioned.emit(self, attack_state.name)
	
	if not owner.target_is_visible:
		Transitioned.emit(self, lose_state.name)
	
	
