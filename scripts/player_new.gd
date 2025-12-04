class_name Player
extends CharacterBody2D

@export var move_speed: float = 100.0

@export var max_health: float = 100.0
@export var current_health: float = 100.0

@export var health_drain_per_second: float = 1.0

@onready var camera := $Camera2D

@export var zoom_in_amount: float = 2.0
@export var zoom_out_amount: float = 1.5
@export var zoom_speed: float = 1.0
@export var move_threshold: float = 10.0

const SCALE_OFFSET := 0.5
const ENERGY_OFFSET := 1.0
const MAX_SCALE := 2.43
const MAX_ENERGY := 1.0

func _ready() -> void:
	$HealthDrainTimer.timeout.connect(_on_health_drain_timer_timeout)

func _process(delta: float) -> void:
	var health_percent: float = current_health / max_health

	if health_percent <= 0.0:
		$LampLight.visible = false
		return
	else:
		$LampLight.visible = true

	var target_energy: float = lerp(0.0, MAX_ENERGY, health_percent)
	var target_scale: float = lerp(0.5, MAX_SCALE, health_percent)

	var energy_off: float = randf_range(-ENERGY_OFFSET, ENERGY_OFFSET)
	$LampLight.energy = lerp($LampLight.energy, target_energy + energy_off, delta * 5)

	var scale_off: float = randf_range(-SCALE_OFFSET, SCALE_OFFSET)
	$LampLight.texture_scale = lerp($LampLight.texture_scale, target_scale + scale_off, delta * 5)


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()

	velocity = direction * move_speed
	move_and_slide()

	camera.position = camera.position.lerp(position, delta * 2)

	var is_moving: bool = velocity.length() > move_threshold
	var target_zoom: Vector2 = Vector2(zoom_in_amount, zoom_in_amount)
	if is_moving:
		target_zoom = Vector2(zoom_out_amount, zoom_out_amount)

	camera.zoom = camera.zoom.lerp(target_zoom, delta * zoom_speed)

func _on_health_drain_timer_timeout() -> void:
	current_health -= health_drain_per_second
	current_health = clamp(current_health, 0, max_health)
