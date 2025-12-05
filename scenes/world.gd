extends Node

@export var noise_height_texture: NoiseTexture2D

var noise : Noise
var length : int = 100
var noise_val_arr = []

@onready var tile_map = $TileMap

var source_id : int = 0
var grass_atlas = Vector2i(0,0)
var stone_atlas = Vector2i(0,4)

func _ready() -> void:
	noise_height_texture.noise.seed = randi()
	noise = noise_height_texture.noise
	
	generate_world()

func _process(delta: float) -> void:
	pass

func generate_world():
	for x in range(-length/2, length/2):
		for y in range(-length/2, length/2):
			var noise_val: float = noise.get_noise_2d(x, y)
			noise_val_arr.append(noise_val)

			if noise_val > 0.0:
				tile_map.set_cell(0, Vector2i(x, y), source_id, grass_atlas)
			else:
				tile_map.set_cell(0, Vector2i(x, y), source_id, stone_atlas)
