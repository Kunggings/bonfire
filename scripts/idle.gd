extends State

var idle_timer: SceneTreeTimer

@export var follow_state: State
@export var wander_state: State

@export var move_speed: float = 0.0
@export var timer_min: float = 0.5
@export var timer_max: float = 5.0

func Enter() -> void:
	
	owner.target = owner.global_position
	
	var wait_time := randf_range(timer_min, timer_max)
	idle_timer = get_tree().create_timer(wait_time)
	idle_timer.timeout.connect(_on_idle_timeout)


func Exit() -> void:

	if idle_timer and idle_timer.timeout.is_connected(_on_idle_timeout):
		idle_timer.timeout.disconnect(_on_idle_timeout)


func Physics_Update(_delta: float) -> void:

	if owner.target_is_visible:
		Transitioned.emit(self, follow_state.name)


func _on_idle_timeout() -> void:
	Transitioned.emit(self, wander_state.name)
