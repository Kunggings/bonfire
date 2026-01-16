extends PointLight2D

var base_energy := energy
var base_texture_scale := texture_scale

@export var min_mult := 0.8
@export var max_mult := 1.2
@export var lerp_speed := 5.0

func _process(delta: float) -> void:
	var energy_mult := randf_range(min_mult, max_mult)
	energy = lerp(
		energy,
		base_energy * energy_mult,
		delta * lerp_speed                    
	)

	var scale_mult := randf_range(min_mult, max_mult)
	texture_scale = lerp(
		texture_scale,
		base_texture_scale * scale_mult,
		delta * lerp_speed
	)
