extends Node
class_name Chunk

var chunk_pos: Vector2i
var chunk_size: int
var floor_noise: FastNoiseLite
var floor_threshold: float = 0.5

var tiles: Array[Vector2i] = []

func _init(
	_chunk_pos: Vector2i,
	_chunk_size: int,
	_noise: FastNoiseLite,
	_threshold: float = 0.5
) -> void:
	chunk_pos = _chunk_pos
	chunk_size = _chunk_size
	floor_noise = _noise
	floor_threshold = _threshold

func generate() -> void:
	tiles.clear()
	tiles.resize(chunk_size * chunk_size)

	for y in range(chunk_size):
		for x in range(chunk_size):
			var world_x = x + chunk_pos.x * chunk_size
			var world_y = y + chunk_pos.y * chunk_size

			var noise_val = floor_noise.get_noise_2d(world_x, world_y)

			var index = x + y * chunk_size

			if noise_val < floor_threshold:
				tiles[index] = Vector2i(1, 1) 
			else:
				tiles[index] = Vector2i(2, 2)
