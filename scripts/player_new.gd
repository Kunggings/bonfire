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
@export var held_item_offset := Vector2(0, -20)

const SCALE_OFFSET := 0.5
const ENERGY_OFFSET := 1.0
const MAX_SCALE := 5
const MAX_ENERGY := 1.0

var held_item: Node2D = null


func _ready() -> void:
	$HealthDrainTimer.timeout.connect(_on_health_drain_timer_timeout)


func _input(event):
	if event.is_action_pressed("Hold"):
		print("try to hold")
		try_grab()
	elif event.is_action_released("Hold"):
		drop_item()


func _process(delta: float) -> void:
	# RenderingServer.global_shader_parameter_set("camera_position", $Camera2D.global_position)

	var health_percent: float = current_health / max_health

	if health_percent <= 0.0:
		$LampLight.visible = false
		return
	else:
		$LampLight.visible = true

	var target_energy: float = lerp(0.0, MAX_ENERGY, health_percent)
	var target_scale: float = lerp(1, MAX_SCALE, health_percent)

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


	if held_item and Input.is_action_pressed("Hold"):
		held_item.global_position = global_position + held_item_offset


func _on_health_drain_timer_timeout() -> void:
	current_health -= health_drain_per_second
	current_health = clamp(current_health, 0, max_health)


func try_grab():
	if held_item:
		return

	var closest_body: StaticBody2D = null
	var closest_distance := INF

	for body in $"Hold-Area2D".get_overlapping_bodies():
		if body is StaticBody2D and body.collision_layer & (1 << 3):
			var distance := global_position.distance_to(body.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_body = body

	if closest_body:
		print("GRABBED:", closest_body.name)
		held_item = closest_body
		held_item.pickupSound()

func drop_item():
	if not held_item:
		return
	held_item.putdownSound()
	held_item.global_position -= held_item_offset*1.25
	held_item = null
