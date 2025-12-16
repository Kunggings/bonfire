extends PointLight2D

var base_energy := energy
var base_texture_scale := texture_scale

@export var SCALE_OFFSET := 0.5
@export var ENERGY_OFFSET := 1.0

func _process(delta: float) -> void:
	var energy_off := randf_range(-ENERGY_OFFSET, ENERGY_OFFSET)
	energy = lerp(energy, base_energy + energy_off, delta*5)

	var scale_off := randf_range(-SCALE_OFFSET, SCALE_OFFSET)
	texture_scale = lerp(texture_scale, base_texture_scale + scale_off, delta*5)
