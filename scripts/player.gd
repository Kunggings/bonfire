class_name Player
extends CharacterBody2D

@export var move_speed: float = 50.0
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


@export var max_health: float = 100.0
@export var current_health: float = 100.0
var health_drain: float = 1.0
var direction: Vector2 = Vector2.ZERO

@export var held_item_offset := Vector2(0, -20)

var held_item: Node2D = null

func _ready() -> void:
	$HealthDrainTimer.timeout.connect(_on_health_drain_timer_timeout)

func _input(event):
	if event.is_action_pressed("Hold"):
		try_grab()
	elif event.is_action_released("Hold"):
		drop_item()
		

func _physics_process(_delta: float) -> void:
	
	
	direction = Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	).normalized()
	

	velocity = direction * move_speed
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false
		
	move_and_slide()

	if held_item and Input.is_action_pressed("Hold"):
		held_item.global_position = global_position + held_item_offset

func _on_health_drain_timer_timeout() -> void:
	current_health = clamp(
		current_health - health_drain,
		0,
		max_health
	)

func try_grab():
	if held_item:
		return

	var closest_body: StaticBody2D = null
	var closest_distance := INF

	for body in $"Hold-Area2D".get_overlapping_bodies():
		if body is StaticBody2D and body.get_collision_layer_value(4):
			var d := global_position.distance_to(body.global_position)
			if d < closest_distance:
				closest_distance = d
				closest_body = body

	if closest_body:
		held_item = closest_body
		held_item.pickupSound()

func drop_item():
	if not held_item:
		return
	held_item.putdownSound()
	held_item.global_position -= held_item_offset * 1.25
	held_item = null

func heal(amount: float) -> void:
	if held_item is Lamp:
		current_health = clamp(current_health + amount, 0.0, max_health)
