extends Camera2D

@export var zoom_in_amount: float = 1.0      # Zoom when still
@export var zoom_out_amount: float = 0.8     # Zoom when moving
@export var zoom_speed: float = 3.0          # Speed of zoom change
@export var move_threshold: float = 10.0     # How much movement counts as "moving"

func _process(delta: float) -> void:
	var player = $"../Player"
	if player == null:
		return

	# --- Smooth follow ---
	position = position.lerp(player.position, delta * 3)

	# --- Check player movement ---
	var is_moving = player.velocity.length() > move_threshold

	# --- Set target zoom based on movement ---
	var target_zoom = Vector2(zoom_in_amount, zoom_in_amount)
	if is_moving:
		target_zoom = Vector2(zoom_out_amount, zoom_out_amount)

	# --- Smooth zoom ---
	zoom = zoom.lerp(target_zoom, delta * zoom_speed)
