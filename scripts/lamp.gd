extends "res://scripts/item.gd"
class_name Lamp

@export var player: CharacterBody2D
@onready var lamp_light: PointLight2D = $LampLight

@export var max_scale: float = 5.0
@export var max_energy: float = 1.0
@export var lerp_speed: float = 5.0

var player_max_health: float
var player_current_health: float


func _ready() -> void:
	if player == null:
		push_error("Player not assigned")
		return

	player_max_health = player.max_health
	lamp_light.enabled = false


func _physics_process(_delta: float) -> void:
	player_current_health = player.current_health


func _process(delta: float) -> void:
	if player_max_health <= 0:
		return

	var health_percent: float = player_current_health / player_max_health
	health_percent = clamp(health_percent, 0.0, 1.0)

	if health_percent <= 0.0:
		lamp_light.enabled = false
		return
	else:
		lamp_light.enabled = true

	var target_energy: float = lerp(0.0, max_energy, health_percent)
	var target_scale: float = lerp(1.0, max_scale, health_percent)

	lamp_light.energy = lerp(
		lamp_light.energy,
		target_energy,
		delta * lerp_speed
	)

	lamp_light.texture_scale = lerp(
		lamp_light.texture_scale,
		target_scale,
		delta * lerp_speed
	)


func pickupSound():
	if pickup_sound:
		pickup_audio.stream = pickup_sound
		pickup_audio.play()


func putdownSound():
	if putdown_sound:
		putdown_audio.stream = putdown_sound
		putdown_audio.play()
