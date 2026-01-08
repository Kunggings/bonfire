extends State
class_name WanderTest

@export var move_speed := 20.0
@export var idle_state: State
@export var follow_state: State

var wander_location : Vector2

@onready var detection_area: Area2D = $"../../DetectionArea"

func Enter() -> void:
	
	wander_location = generate_wander_location()

func Exit() -> void:
	pass

func Physics_Update(_delta: float) -> void:
	
	var to_target : Vector2 = wander_location - owner.global_position
	owner.velocity = to_target.normalized() * move_speed
	
	if wander_location.distance_to(owner.global_position) <= 1 :
		Transitioned.emit(self, idle_state.name)
	
	if owner.target_is_visible == true:
		Transitioned.emit(self, follow_state.name)

	
func generate_wander_location() -> Vector2:
	var shape = detection_area.get_node("CollisionShape2D").shape
	var radius = shape.radius

	var angle = randf() * TAU
	var distance = sqrt(randf()) * radius
	var offset = Vector2(cos(angle), sin(angle)) * distance

	return detection_area.global_position + offset
