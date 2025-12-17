extends CharacterBody2D

enum State {
	IDLE,
	ACTIVE,
	SEARCHING
}

@onready var target: Player = $"../Player"
@onready var raycast: RayCast2D = $RayCast2D
@onready var detection_area: Area2D = $DetectionArea

@export var speed: float = 30.0
@export var idle_speed: float = 15.0
@export var max_wander_distance: float = 100.0
@export var wander_time_range := Vector2(1.0, 2.5)
@export var pause_time_range := Vector2(0.5, 1.5)

var state: State = State.IDLE
var player_in_range := false
var wander_direction := Vector2.ZERO
var wander_timer := 0.0
var pausing := false
var start_position: Vector2
var last_known_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	start_position = global_position
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	start_idle_cycle()
	raycast.enabled = true
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true
	raycast.collision_mask = (1 << 1) | target.collision_layer

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			idle_state(delta)
		State.ACTIVE:
			active_state()
		State.SEARCHING:
			search_state()
	move_and_slide()

func idle_state(delta: float) -> void:
	if player_in_range:
		look_for_player()
		if can_see_player():
			state = State.ACTIVE
			last_known_position = target.global_position
			return
	wander_timer -= delta
	if wander_timer <= 0.0:
		if pausing:
			start_wander()
		else:
			start_pause()
	if pausing:
		velocity = Vector2.ZERO
	else:
		if global_position.distance_to(start_position) > max_wander_distance:
			wander_direction = (start_position - global_position).normalized()
		velocity = wander_direction * idle_speed

func active_state() -> void:
	look_for_player()
	if can_see_player():
		last_known_position = target.global_position
	else:
		state = State.SEARCHING
		return
	var direction := (target.global_position - global_position).normalized()
	velocity = direction * speed

func search_state() -> void:
	if global_position.distance_to(last_known_position) < 5.0:
		state = State.IDLE
		start_idle_cycle()
		return
	var direction := (last_known_position - global_position).normalized()
	velocity = direction * speed
	look_for_player()
	if can_see_player():
		state = State.ACTIVE
		last_known_position = target.global_position

func start_idle_cycle() -> void:
	start_wander()

func start_wander() -> void:
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer = randf_range(wander_time_range.x, wander_time_range.y)
	pausing = false

func start_pause() -> void:
	wander_timer = randf_range(pause_time_range.x, pause_time_range.y)
	pausing = true

func _on_body_entered(body: Node) -> void:
	if body == target:
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body == target:
		player_in_range = false
		raycast.force_raycast_update()

func look_for_player() -> void:
	raycast.target_position = to_local(target.global_position)
	raycast.force_raycast_update()

func can_see_player() -> bool:
	if not raycast.is_colliding():
		return false
	var collider := raycast.get_collider()
	if collider is CollisionObject2D and collider.collision_layer & (1 << 1) != 0:
		return false
	return collider == target
