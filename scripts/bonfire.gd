extends Area2D
class_name Bonfire

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var lit_texture := preload("res://textures/bonfire.png")
@export var heal_amount: float = 50.0

var bonfire_lit := false

var bonfire_scale := 3
var bonfire_energy := 1.00
const SCALE_OFFSET := 0.5
const ENERGY_OFFSET := 1.0

func _process(delta: float) -> void:
	if bonfire_lit:
		var energy_off := randf_range(-ENERGY_OFFSET, ENERGY_OFFSET)
		$FlameLight.energy = lerp($FlameLight.energy, bonfire_energy + energy_off, delta*5)

		var scale_off := randf_range(-SCALE_OFFSET, SCALE_OFFSET)
		$FlameLight.texture_scale = lerp($FlameLight.texture_scale, bonfire_scale + scale_off, delta*5)

func _on_body_entered(body: Node2D) -> void:
	if body is not Player or bonfire_lit:
		return
	
	body.heal(heal_amount)
	
	bonfire_lit = true

	gpu_particles_2d.emitting = true
	
	$BonfireLitSound.play()
	$BonfireSound.play()

	$Sprite.texture = lit_texture
	$FlameLight.visible = true
