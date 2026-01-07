extends State
class_name FollowTest

var target: CharacterBody2D
var character: CharacterBody2D
var target_is_visiable: bool

@export var move_speed := 20.0
@export var lose_state: State 

@onready var detection_area: Area2D = $"../../DetectionArea"

func Enter() -> void:
	
	target_is_visiable = true

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

	var to_target := target.global_position - character.global_position
	character.velocity = to_target.normalized() * move_speed
	
	if target_is_visiable == false:
		Transitioned.emit(self, lose_state.name)


func _on_body_entered(body: Node) -> void:
	if body == target:
		target_is_visiable = true

func _on_body_exited(body: Node) -> void:
	if body == target:
		target_is_visiable = false

	
