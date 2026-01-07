extends State
class_name IdleTest

var character: CharacterBody2D
var target: CharacterBody2D
var target_is_visible: bool = false
var idle_timer: SceneTreeTimer

@export var follow_state: State
@export var wander_state: State

@export var timer_min: float = 0.5
@export var timer_max: float = 5.0

@onready var detection_area: Area2D = $"../../DetectionArea"


func Enter() -> void:
	character = owner as CharacterBody2D
	character.velocity = Vector2.ZERO
	target_is_visible = false

	var wait_time := randf_range(timer_min, timer_max)
	idle_timer = get_tree().create_timer(wait_time)
	idle_timer.timeout.connect(_on_idle_timeout)

	if not detection_area.body_entered.is_connected(_on_body_entered):
		detection_area.body_entered.connect(_on_body_entered)

	if not detection_area.body_exited.is_connected(_on_body_exited):
		detection_area.body_exited.connect(_on_body_exited)


func Exit() -> void:
	if detection_area.body_entered.is_connected(_on_body_entered):
		detection_area.body_entered.disconnect(_on_body_entered)

	if detection_area.body_exited.is_connected(_on_body_exited):
		detection_area.body_exited.disconnect(_on_body_exited)

	if idle_timer and idle_timer.timeout.is_connected(_on_idle_timeout):
		idle_timer.timeout.disconnect(_on_idle_timeout)


func Physics_Update(_delta: float) -> void:
	character.velocity = Vector2.ZERO

	if target_is_visible:
		Transitioned.emit(self, follow_state.name)


func _on_idle_timeout() -> void:
	Transitioned.emit(self, wander_state.name)


func _on_body_entered(body: Node) -> void:
	if body == target:
		target_is_visible = true


func _on_body_exited(body: Node) -> void:
	if body == target:
		target_is_visible = false
