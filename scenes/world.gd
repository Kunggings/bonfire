extends Node

@export var map_size := 100

@export var noise_height_texture: NoiseTexture2D
@export var tree_texture: NoiseTexture2D

# ====== ADJUSTABLE THRESHOLDS ======
@export var grass_threshold: float = 0.0      # Above this = grass
@export var stone_threshold: float = -0.1     # Below this = stone
var tree_threshold: float = 0.8       # Above this = tree
# ===================================

var noise: Noise
var tree_noise: Noise

var source_id := 0
var tree_source_id := 3

var grass_atlas_arr := [
	Vector2i(0,0), Vector2i(0,1), Vector2i(0,2), Vector2i(0,3),
	Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3),
	Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3),
	Vector2i(3,0), Vector2i(3,1), Vector2i(3,2), Vector2i(3,3),
	Vector2i(4,0), Vector2i(4,1), Vector2i(4,2), Vector2i(4,3),
	Vector2i(5,0), Vector2i(5,1), Vector2i(5,2), Vector2i(5,3),
	Vector2i(6,0), Vector2i(6,1), Vector2i(6,2), Vector2i(6,3),
	Vector2i(7,0), Vector2i(7,1), Vector2i(7,2), Vector2i(7,3)
]

var stone_atlas_arr := [
	Vector2i(0,4), Vector2i(0,5), Vector2i(0,6),
	Vector2i(1,4), Vector2i(1,5), Vector2i(1,6)
]

var edge_stone_atlas_arr := [
	Vector2i(0,7), Vector2i(1,7),
	Vector2i(2,4), Vector2i(3,4), Vector2i(4,4), Vector2i(5,4), Vector2i(6,4), Vector2i(7,4),
	Vector2i(2,5), Vector2i(3,5), Vector2i(4,5), Vector2i(5,5), Vector2i(6,5), Vector2i(7,5),
	Vector2i(2,6), Vector2i(3,6), Vector2i(4,6), Vector2i(5,6), Vector2i(6,6), Vector2i(7,6),
	Vector2i(2,7), Vector2i(3,7), Vector2i(4,7), Vector2i(5,7)
]

var tree_atlas_arr := [
	Vector2i(9,1), Vector2i(5,0)
]

@onready var layer_floor: TileMapLayer = $"Layer Floor"
@onready var layer_tree: TileMapLayer = $"Layer Tree"

func _ready() -> void:
	noise_height_texture.noise.seed = randi()
	tree_texture.noise.seed = randi()

	noise = noise_height_texture.noise
	tree_noise = tree_texture.noise

	generate_world()

func generate_world():
	for x in range(-map_size / 2, map_size / 2):
		for y in range(-map_size / 2, map_size / 2):

			var noise_val := noise.get_noise_2d(x, y)
			var tree_noise_val := tree_noise.get_noise_2d(x, y)

			# --------- TERRAIN BASED ON THRESHOLDS ---------
			if noise_val > grass_threshold:
				layer_floor.set_cell(Vector2i(x, y), source_id, grass_atlas_arr.pick_random())

				if tree_noise_val > tree_threshold:
					layer_tree.set_cell(Vector2i(x, y), tree_source_id, tree_atlas_arr.pick_random())

			elif noise_val < stone_threshold:
				layer_floor.set_cell(Vector2i(x, y), source_id, stone_atlas_arr.pick_random())

			else:
				layer_floor.set_cell(Vector2i(x, y), source_id, edge_stone_atlas_arr.pick_random())
