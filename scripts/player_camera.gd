extends Camera2D

@export var zoom_in_amount: float = 2.0
@export var zoom_out_amount: float = 1.5
@export var zoom_speed: float = 1.0
@export var move_threshold: float = 10.0
@export var follow_speed: float = 2.0

func _process(delta: float) -> void:
	
	position = position.lerp(owner.global_position, delta * follow_speed)


	var is_moving = owner.velocity.length() > move_threshold
	var target_zoom := Vector2(zoom_in_amount, zoom_in_amount)

	if is_moving:
		target_zoom = Vector2(zoom_out_amount, zoom_out_amount)

	zoom = zoom.lerp(target_zoom, delta * zoom_speed)
