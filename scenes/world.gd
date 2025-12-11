extends Node

@export var noise_height_texture: NoiseTexture2D
@export var tree_texture: NoiseTexture2D

var noise: Noise
var tree_noise: Noise
var length := 100

var source_id := 0
var tree_source_id := 3
var grass_atlas := Vector2i(0, 0)
var stone_atlas := Vector2i(0, 4)
var tree_atlas_arr := [Vector2i(9,1), Vector2i(5,0)]

@onready var layer_floor: TileMapLayer = $"Layer Floor"
@onready var layer_tree: TileMapLayer = $"Layer Tree"

func _ready() -> void:
	noise_height_texture.noise.seed = randi()
	tree_texture.noise.seed = randi()

	noise = noise_height_texture.noise
	tree_noise = tree_texture.noise

	generate_world()

func generate_world():
	for x in range(-length / 2, length / 2):
		for y in range(-length / 2, length / 2):

			var noise_val := noise.get_noise_2d(x, y)
			var tree_noise_val := tree_noise.get_noise_2d(x, y)

			# --- Ground ---
			if noise_val > 0.0:
				layer_floor.set_cell(Vector2i(x, y), source_id, grass_atlas)
				if tree_noise_val > 0.8:
					layer_tree.set_cell(Vector2i(x, y), tree_source_id, tree_atlas_arr.pick_random())
			else:
				layer_floor.set_cell(Vector2i(x, y), source_id, stone_atlas)
