class_name Player
extends CharacterBody2D

@export var move_speed: float = 100.0

@export var max_health: float = 100.0
@export var current_health: float = 100.0

@export var health_drain_per_second: float = 1.0  # How much health to lose every tick

@onready var camera := $Camera2D

@export var zoom_in_amount: float = 2.0      # Zoom when still
@export var zoom_out_amount: float = 1.5     # Zoom when moving
@export var zoom_speed: float = 1.0          # Speed of zoom change
@export var move_threshold: float = 10.0     # How much movement counts as "moving"


func _ready() -> void:
	$HealthDrainTimer.timeout.connect(_on_health_drain_timer_timeout)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	velocity = direction * move_speed

	move_and_slide()

	# --- update camera
	camera.position = camera.position.lerp(position, delta*2)

	var is_moving = velocity.length() > move_threshold

	var target_zoom = Vector2(zoom_in_amount, zoom_in_amount)
	if is_moving:
		target_zoom = Vector2(zoom_out_amount, zoom_out_amount)

	camera.zoom = camera.zoom.lerp(target_zoom, delta * zoom_speed)


func _on_health_drain_timer_timeout() -> void:
	# Reduce health each time the timer triggers
	current_health -= health_drain_per_second
	current_health = clamp(current_health, 0, max_health)
