extends CharacterBody2D
@onready var target: Player = $"../Player"

const SPEED = 30.0

func _physics_process(delta: float) -> void:
	var direction = (target.position - position).normalized()
	velocity = direction * SPEED
	move_and_slide()
