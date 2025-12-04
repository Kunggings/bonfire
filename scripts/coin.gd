extends Area2D

@export var lit_texture := preload("res://textures/bonfire.png")
@export var heal_amount: float = 10.0

var light_flicker_enabled := false
var bonfire_lit := false   # <<< changed to bonfire_lit


func _process(delta: float) -> void:
	if light_flicker_enabled:
		flicker()


func flicker() -> void:
	var target := randf_range(0.7, 1.3)
	$FlameLight.energy = lerp($FlameLight.energy, target, 0.1)


func _on_body_entered(body: Node2D) -> void:
	# Only allow the bonfire to activate once
	if bonfire_lit:
		return

	bonfire_lit = true  

	print("Bonfire")

	# Heal the player
	
	body.current_health = min(body.current_health + heal_amount, body.max_health)

	# Visuals
	$Sprite.texture = lit_texture
	$FlameLight.visible = true
	light_flicker_enabled = true
