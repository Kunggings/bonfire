extends State
class_name WanderTest

var target: CharacterBody2D
var character: CharacterBody2D
var target_is_visiable: bool

@export var move_speed := 20.0
@export var idle_state: State
@export var follow_state: State

var wander_location : Vector2

@onready var detection_area: Area2D = $"../../DetectionArea"

func Enter() -> void:
	
	target_is_visiable = false
	
	wander_location = generate_wander_location()

	if not detection_area.body_entered.is_connected(_on_body_entered):
		detection_area.body_entered.connect(_on_body_entered)

	if not detection_area.body_exited.is_connected(_on_body_exited):
		detection_area.body_exited.connect(_on_body_exited)

func Exit() -> void:
	if detection_area.body_entered.is_connected(_on_body_entered):
		detection_area.body_entered.disconnect(_on_body_entered)

	if detection_area.body_exited.is_connected(_on_body_exited):
		detection_area.body_exited.disconnect(_on_body_exited)

func Physics_Update(_delta: float) -> void:

	var to_target := wander_location - character.global_position
	character.velocity = to_target.normalized() * move_speed
	
	if wander_location.distance_to(character.global_position) <= 1 :
		#print("Wander")
		Transitioned.emit(self, idle_state.name)
	
	if target_is_visiable == true:
		Transitioned.emit(self, follow_state.name)


func _on_body_entered(body: Node) -> void:
	if body == target:
		target_is_visiable = true

func _on_body_exited(body: Node) -> void:
	if body == target:
		target_is_visiable = false

	
func generate_wander_location() -> Vector2:
	var shape = detection_area.get_node("CollisionShape2D").shape
	var radius = shape.radius

	var angle = randf() * TAU
	var distance = sqrt(randf()) * radius
	var offset = Vector2(cos(angle), sin(angle)) * distance

	return detection_area.global_position + offset
