extends CharacterBody2D

enum State {
	IDLE,
	ACTIVE,
	SEARCH
}

@export var state: State = State.IDLE

@export var target: CharacterBody2D
@export var speed: float = 20.0
@export var acceleration: float = 400.0

@export var idle_speed: float = 12.0
@export var wander_radius: float = 80.0
@export var idle_pause_time: float = 1.0

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_area: Area2D = $DetectionArea
@onready var line_of_sight: RayCast2D = $LineOfSight

var target_in_range := false
var has_line_of_sight := false
var last_known_position: Vector2 = Vector2.ZERO

var idle_timer := 0.0
var is_idling := true

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			_update_idle(delta)
		State.ACTIVE:
			_update_active(delta)
		State.SEARCH:
			_update_search(delta)


# ======================
# ACTIVE / CHASE
# ======================
func _update_active(delta: float) -> void:
	if not target:
		return

	_update_line_of_sight()

	if not target_in_range or not has_line_of_sight:
		last_known_position = target.global_position
		state = State.SEARCH
		return

	agent.target_position = target.global_position

	if agent.is_navigation_finished():
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		move_and_slide()
		return

	var next_point := agent.get_next_path_position()
	var direction := (next_point - global_position).normalized()
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()


# ======================
# SEARCH / MOVE TO LAST KNOWN POSITION
# ======================
func _update_search(delta: float) -> void:
	# If agent finished moving, go idle
	if agent.is_navigation_finished():
		state = State.IDLE
		is_idling = true
		idle_timer = idle_pause_time
		return

	var next_point := agent.get_next_path_position()
	var direction := (next_point - global_position).normalized()
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()


# ======================
# IDLE / WANDER
# ======================
func _update_idle(delta: float) -> void:
	if is_idling:
		idle_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		move_and_slide()

		if idle_timer <= 0.0:
			_set_new_wander_target()
		return

	if agent.is_navigation_finished():
		is_idling = true
		idle_timer = idle_pause_time
		return

	var next_point := agent.get_next_path_position()
	var direction := (next_point - global_position).normalized()
	var desired_velocity := direction * idle_speed
	velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	move_and_slide()


func _set_new_wander_target() -> void:
	is_idling = false
	var random_offset := Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	agent.target_position = global_position + random_offset


# ======================
# LINE OF SIGHT
# ======================
func _update_line_of_sight() -> void:
	if not target_in_range:
		has_line_of_sight = false
		return

	line_of_sight.target_position = line_of_sight.to_local(target.global_position)
	line_of_sight.force_raycast_update()

	if line_of_sight.is_colliding():
		has_line_of_sight = line_of_sight.get_collider() == target
	else:
		has_line_of_sight = false


# ======================
# DETECTION
# ======================
func _on_body_entered(body: Node) -> void:
	if body == target:
		state = State.ACTIVE
		target_in_range = true
		is_idling = false


func _on_body_exited(body: Node) -> void:
	if body == target:
		target_in_range = false
		has_line_of_sight = false
		last_known_position = target.global_position
		state = State.SEARCH
