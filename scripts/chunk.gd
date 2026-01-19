extends Node
class_name Chunk

var chunk_pos: Vector2i
var chunk_size: int
var floor_noise: FastNoiseLite
var object_noise: FastNoiseLite
var plant_noise: FastNoiseLite
var floor_threshold: float 
var grass_threshold: float
var stone_threshold: float

var tiles: Array[Array] = []

static var grass_atlas: Array[Vector2i] = [
	Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0),
	Vector2i(4,0), Vector2i(5,0), Vector2i(6,0), Vector2i(7,0),

	Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1),
	Vector2i(4,1), Vector2i(5,1), Vector2i(6,1), Vector2i(7,1),

	Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), Vector2i(3,2),
	Vector2i(4,2), Vector2i(5,2), Vector2i(6,2), Vector2i(7,2),

	Vector2i(0,3), Vector2i(1,3), Vector2i(2,3), Vector2i(3,3),
	Vector2i(4,3), Vector2i(5,3), Vector2i(6,3), Vector2i(7,3),
]

static var stone_atlas: Array[Vector2i] = [
	Vector2i(0,4), Vector2i(0,5), Vector2i(0,6),
	Vector2i(1,4), Vector2i(1,5), Vector2i(1,6), 
]

static var broken_atlas: Array[Vector2i] = [
	Vector2i(2,4), Vector2i(3,4), Vector2i(4,4), Vector2i(5,4), Vector2i(6,4), Vector2i(7,4),
	Vector2i(2,5), Vector2i(3,5), Vector2i(4,5), Vector2i(5,5), Vector2i(6,5), Vector2i(7,5),
	Vector2i(2,6), Vector2i(3,6), Vector2i(4,6), Vector2i(5,6), Vector2i(6,6), Vector2i(7,6),
	Vector2i(2,7), Vector2i(3,7), Vector2i(4,7), Vector2i(5,7),
]

static var objects: Array[Vector2i] = [
	Vector2i(3,0), Vector2i(5,0), Vector2i(7,0), Vector2i(9,0),Vector2i(13,0)
]

static var plants: Array[Vector2i] = [
	Vector2i(0,0), Vector2i(5,0), Vector2i(9,0),
]


func _init(
	_chunk_pos: Vector2i,
	_chunk_size: int,
	_floor_noise: FastNoiseLite,
	_object_noise: FastNoiseLite,
	_plant_noise: FastNoiseLite,
	_stone_threshold: float,
	_grass_threshold: float
) -> void:
	chunk_pos = _chunk_pos
	chunk_size = _chunk_size
	floor_noise = _floor_noise
	object_noise = _object_noise
	plant_noise = _plant_noise
	stone_threshold = _stone_threshold
	grass_threshold = _grass_threshold
	tiles = [
		[], # floor layer
		[],  # object layer
		[], #plant layer
	]


func generate() -> void:
	tiles[0].resize(chunk_size * chunk_size)
	tiles[1].resize(chunk_size * chunk_size)
	tiles[2].resize(chunk_size * chunk_size)

	for y in range(chunk_size):
		for x in range(chunk_size):
			var world_x = x + chunk_pos.x * chunk_size
			var world_y = y + chunk_pos.y * chunk_size 

			var floor_noise_val = floor_noise.get_noise_2d(world_x, world_y)
			var object_noise_val = object_noise.get_noise_2d(world_x, world_y)
			var plants_noise_val = plant_noise.get_noise_2d(world_x, world_y)

			var index = x + y * chunk_size

			if floor_noise_val > grass_threshold:
				tiles[0][index] = grass_atlas.pick_random()
				if plants_noise_val > 0.3:
					tiles[2][index] = plants.pick_random()
				
			elif floor_noise_val < stone_threshold:
				tiles[0][index] = stone_atlas.pick_random()
				if object_noise_val > 0.5:
					tiles[1][index] = objects.pick_random()
					
			else: 
				tiles[0][index] = broken_atlas.pick_random()

		
	# var label = Label.new()
	# label.text = "%s, %s" % [chunk_pos.x, chunk_pos.y]
	# label.global_position = chunk_pos * chunk_size * 32
	# add_child(label)
