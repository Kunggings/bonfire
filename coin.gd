extends Area2D

@export var lit_texture := preload("res://bonfire.png")

var light_flicker_enabled := false

func _process(delta: float) -> void:
	if light_flicker_enabled:
		flicker()

func flicker() -> void:
	var tween := create_tween()
	var new_energy := randf_range(0.7, 1.3)
	tween.tween_property($FlameLight, "energy", new_energy, 0.1)

func _on_body_entered(body: Node2D) -> void:
	print("Bonfire")

	$Sprite.texture = lit_texture

	$FlameLight.visible = true
	light_flicker_enabled = true

	set_deferred("monitoring", false)
