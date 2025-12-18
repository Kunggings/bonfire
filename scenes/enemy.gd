extends CharacterBody2D

enum State {
	IDLE,
	ACTIVE,
	SEARCHING
}

@export var speed: float = 60.0
@export var idle_speed: float = 25.0
@export var wander_radius: float = 100.0

@export var idle_pause_time := Vector2(0.5, 1.5)
@export var search_time: float = 2.0
@export var search_speed: float = 40.0

@onready var detection_area: Area2D = $DetectionArea
@onready var raycast: RayCast2D = $RayCast2D
@onready var player: CharacterBody2D = $"../Player"

var state: State = State.IDLE
var target: CharacterBody2D = null
var player_in_range := false

var spawn_position: Vector2
var wander_target: Vector2
var idle_timer := 0.0
var is_paused := false

var last_known_position: Vector2
var search_timer := 0.0

# -------------------------------------------------

func _ready():
	spawn_position = global_position
	_pick_new_wander_target()

	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

# -------------------------------------------------

func _physics_process(delta):
	if target:
		_update_raycast()

	match state:
		State.IDLE:
			_idle_behavior(delta)

		State.ACTIVE:
			_chase_player()

		State.SEARCHING:
			_search_behavior(delta)

	move_and_slide()

# -------------------------------------------------
# IDLE
# -------------------------------------------------

func _idle_behavior(delta):
	if is_paused:
		idle_timer -= delta
		velocity = Vector2.ZERO

		if idle_timer <= 0.0:
			is_paused = false
			_pick_new_wander_target()
		return

	var direction = wander_target - global_position

	if direction.length() < 5.0:
		is_paused = true
		idle_timer = randf_range(idle_pause_time.x, idle_pause_time.y)
		velocity = Vector2.ZERO
		return

	velocity = direction.normalized() * idle_speed

# -------------------------------------------------
# ACTIVE
# -------------------------------------------------

func _chase_player():
	if not target:
		state = State.IDLE
		return

	if _can_see_player():
		last_known_position = target.global_position
		var direction = (last_known_position - global_position).normalized()
		velocity = direction * speed
	else:
		state = State.SEARCHING
		search_timer = search_time

# -------------------------------------------------
# SEARCHING
# -------------------------------------------------

func _search_behavior(delta):
	var direction = last_known_position - global_position

	if direction.length() > 5.0:
		velocity = direction.normalized() * search_speed
	else:
		velocity = Vector2.ZERO
		search_timer -= delta

		if search_timer <= 0.0:
			state = State.IDLE
			target = null
			_pick_new_wander_target()

# -------------------------------------------------
# WANDER
# -------------------------------------------------

func _pick_new_wander_target():
	var angle = randf() * TAU
	var radius = randf() * wander_radius
	wander_target = spawn_position + Vector2(cos(angle), sin(angle)) * radius

# -------------------------------------------------
# DETECTION
# -------------------------------------------------

func _on_body_entered(body):
	if body == player:
		player_in_range = true
		target = body
		state = State.ACTIVE

func _on_body_exited(body):
	if body == player:
		player_in_range = false

		if state == State.ACTIVE:
			last_known_position = body.global_position
			state = State.SEARCHING
			search_timer = search_time
		# DO NOT clear target here

# -------------------------------------------------
# RAYCAST
# -------------------------------------------------

func _update_raycast():
	raycast.target_position = raycast.to_local(target.global_position)
	raycast.force_raycast_update()

func _can_see_player() -> bool:
	return raycast.is_colliding() and raycast.get_collider() == player
