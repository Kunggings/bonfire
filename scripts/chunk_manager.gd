extends TileMapLayer
class_name ChunkManager

@export var chunk_size: int = 4
@export var floor_noise: FastNoiseLite
@export var floor_threshold: float = 0.5
var tile_size := tile_set.tile_size.x
var chunk_load_radius := 1

var generated_chunks: Dictionary[Vector2i, Chunk] = {}
var drawn_chunks: Dictionary[Vector2i, Chunk] = {}

@onready var player: Player = $"../Player"
@onready var player_chunk: Vector2i = world_to_chunk_pos(player.global_position)
var prev_player_chunk := Vector2i.MAX


func _physics_process(_delta: float) -> void:
	player_chunk = world_to_chunk_pos(player.global_position)

	if prev_player_chunk != player_chunk:
		generate_chunks_around_player(player_chunk)
		prev_player_chunk = player_chunk

	unload_check()


func generate_chunks_around_player(_player_chunk: Vector2i) -> void:
	for y_offset in range(-chunk_load_radius, chunk_load_radius + 1):
		for x_offset in range(-chunk_load_radius, chunk_load_radius + 1):
			var chunk_pos := _player_chunk + Vector2i(x_offset, y_offset)

			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)

			draw_chunk(chunk_pos, 1)


func unload_check() -> void:
	for chunk in drawn_chunks:
		var delta = drawn_chunks[chunk].chunk_pos - player_chunk

		if abs(delta.x) > 2 or abs(delta.y) > 2:
			remove_chunk(drawn_chunks[chunk].chunk_pos)


func world_to_chunk_pos(world_pos: Vector2) -> Vector2i:
	var tile_x = floor(world_pos.x / tile_size)
	var tile_y = floor(world_pos.y / tile_size)

	return Vector2i(
		floor(tile_x / chunk_size),
		floor(tile_y / chunk_size)
	)


func generate_chunk(chunk_pos: Vector2i) -> void:
	if generated_chunks.has(chunk_pos):
		return

	var chunk := Chunk.new(
		chunk_pos,
		chunk_size,
		floor_noise,
		floor_threshold
	)

	add_child(chunk)
	chunk.generate()

	generated_chunks[chunk_pos] = chunk
	#print("%v generated" % chunk_pos)


func draw_chunk(chunk_pos: Vector2i, tile_map_id: int) -> void:
	if drawn_chunks.has(chunk_pos):
		return

	var chunk: Chunk = generated_chunks[chunk_pos]
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

	drawn_chunks[chunk_pos] = chunk
	#print("%v drawn" % chunk_pos)


func remove_chunk(chunk_pos: Vector2i) -> void:
	var chunk_origin := chunk_pos * chunk_size

	for y in range(chunk_size):
		for x in range(chunk_size):
			var tile_pos := Vector2i(
				chunk_origin.x + x,
				chunk_origin.y + y
			)

			erase_cell(tile_pos)

	drawn_chunks.erase(chunk_pos)
	#print("%v removed" % chunk_pos)
