extends Node

@export var noise_height_texture: NoiseTexture2D
@export var tree_texture: NoiseTexture2D

var noise : Noise
var tree_noise : Noise
var length : int = 100
var noise_val_arr = []

@onready var tile_map = $TileMap

var source_id : int = 0
var tree_source_id : int = 3
var grass_atlas = Vector2i(0,0)
var stone_atlas = Vector2i(0,4)
var tree_atlas_arr = [Vector2i(9,1),Vector2i(5,0)]

func _ready() -> void:
	noise_height_texture.noise.seed = randi()
	noise = noise_height_texture.noise
	tree_texture.noise.seed = randi()
	tree_noise = tree_texture.noise
	generate_world()

func _process(delta: float) -> void:
	pass

func generate_world():
	for x in range(-length/2 as int, length/2 as int):
		for y in range(-length/2 as int, length/2 as int):
			
			var noise_val: float = noise.get_noise_2d(x, y)
			var tree_noise_val: float = tree_noise.get_noise_2d(x, y)

			noise_val_arr.append(noise_val)

			# ----- Ground -----
			if noise_val > 0.0:
				tile_map.set_cell(0, Vector2i(x, y), source_id, grass_atlas)
			else:
				tile_map.set_cell(0, Vector2i(x, y), source_id, stone_atlas)

			# ----- Trees -----
			if tree_noise_val > 0.8:
				#print("TREE AT:", x, "  ", y)
				tile_map.set_cell(1, Vector2i(x, y), tree_source_id, tree_atlas_arr.pick_random())
