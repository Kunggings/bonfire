extends TileMapLayer
class_name ChunkManager

@export var chunk_size: int = 4
@export var floor_noise: FastNoiseLite
@export var floor_threshold: float = 0.5
var tile_size := tile_set.tile_size.x
var chunk_load_radius := 1

var generated_chunks: Array[Chunk] = []
var drawn_chunks: Array[Chunk] = []

@onready var player: Player = $"../Player"
@onready var player_chunk = world_to_chunk_pos(player.global_position)

func _physics_process(_delta: float) -> void:
	player_chunk = world_to_chunk_pos(player.global_position)

	generate_chunks_around_player(player_chunk)
	unload_check()
	
func generate_chunks_around_player(_player_chunk: Vector2i) -> void:
	for y_offset in range(-chunk_load_radius, chunk_load_radius + 1):
		for x_offset in range(-chunk_load_radius, chunk_load_radius + 1):
			var chunk_pos := _player_chunk + Vector2i(x_offset, y_offset)
			
			if not is_chunk_generated(chunk_pos):
				generate_chunk(chunk_pos)
				draw_chunk(generated_chunks.back(), 1)
			else:
				var chunk := get_generated_chunk(chunk_pos)
				draw_chunk(chunk, 1)

func unload_check() -> void:
	for chunk in drawn_chunks.duplicate():
		var delta = chunk.chunk_pos - player_chunk

		if abs(delta.x) > 2 or abs(delta.y) > 2:
			remove_chunk(chunk)

func get_generated_chunk(chunk_pos: Vector2i) -> Chunk:
	for chunk in generated_chunks:
		if chunk.chunk_pos == chunk_pos:
			return chunk
	return null	

func is_chunk_generated(chunk_pos: Vector2i) -> bool:
	for c in generated_chunks:
		if c.chunk_pos == chunk_pos:
			return true
	return false

func world_to_chunk_pos(world_pos: Vector2) -> Vector2i:
	var tile_x = floor(world_pos.x / tile_size)
	var tile_y = floor(world_pos.y / tile_size)

	return Vector2i(
		floor(tile_x / chunk_size),
		floor(tile_y / chunk_size)
	)

func generate_chunk(chunk_pos: Vector2i) -> void:
	for c in generated_chunks:
		if c.chunk_pos == chunk_pos:
			return

	var chunk := Chunk.new(
		chunk_pos,
		chunk_size,
		floor_noise,
		floor_threshold
	)

	add_child(chunk)
	chunk.generate()

	generated_chunks.append(chunk)

func draw_chunk(chunk: Chunk, tile_map_id: int) -> void:
	var chunk_origin := chunk.chunk_pos * chunk_size

	for y in range(chunk_size):
		for x in range(chunk_size):
			var index := x + y * chunk_size
			var atlas_coords := chunk.tiles[index]

			var tile_pos := Vector2i(
				chunk_origin.x + x,
				chunk_origin.y + y
			)

			set_cell(
				tile_pos,
				tile_map_id,
				atlas_coords
			)

	drawn_chunks.append(chunk)

func remove_chunk(chunk: Chunk) -> void:
	var chunk_origin := chunk.chunk_pos * chunk_size

	for y in range(chunk_size):
		for x in range(chunk_size):
			var tile_pos := Vector2i(
				chunk_origin.x + x,
				chunk_origin.y + y
			)

			erase_cell(tile_pos)

	drawn_chunks.erase(chunk)
