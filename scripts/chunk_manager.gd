extends TileMapLayer
class_name ChunkManager

@export var chunk_size: int = 4
@export var floor_noise: FastNoiseLite
@export var object_noise: FastNoiseLite
@export var plant_noise: FastNoiseLite
@export var grass_threshold: float = 0.1
@export var stone_threshold: float = -0.1

@onready var object: TileMapLayer = $"../Object"
@onready var plants: TileMapLayer = $"../Plants"

var tile_size := tile_set.tile_size.x
var chunk_load_radius := 1

var generated_chunks: Dictionary[Vector2i, Chunk] = {}
var drawn_chunks: Dictionary[Vector2i, Chunk] = {}
var drawn_bonfires: Dictionary[Vector2i, Bonfire] = {}

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
			unload_chunk(drawn_chunks[chunk].chunk_pos)


func world_to_chunk_pos(world_pos: Vector2) -> Vector2i:
	var tile_x = floor(world_pos.x / tile_size)
	var tile_y = floor(world_pos.y / tile_size)

	return Vector2i(
		floor(tile_x / chunk_size),
		floor(tile_y / chunk_size)
	)


func chunk_to_world_pos(chunk_pos: Vector2i) -> Vector2:
	return Vector2(
		chunk_pos.x * chunk_size * tile_size,
		chunk_pos.y * chunk_size * tile_size
	)


func tile_to_world_pos(tile_pos: Vector2i) -> Vector2:
	return Vector2i(
		tile_pos.x * tile_size,
		tile_pos.y * tile_size
	)


func generate_chunk(chunk_pos: Vector2i) -> void:
	if generated_chunks.has(chunk_pos):
		return

	var chunk := Chunk.new(
		chunk_pos,
		chunk_size,
		floor_noise,
		object_noise,
		plant_noise,
		stone_threshold,
		grass_threshold
	)

	add_child(chunk)
	chunk.generate()

	generated_chunks[chunk_pos] = chunk


func draw_chunk(chunk_pos: Vector2i, tile_map_id: int) -> void:
	if drawn_chunks.has(chunk_pos):
		return

	var chunk: Chunk = generated_chunks[chunk_pos]
	var chunk_origin := chunk.chunk_pos * chunk_size

	for y in range(chunk_size):
		for x in range(chunk_size):
			var index := x + y * chunk_size
			var atlas_coords = chunk.tiles[0][index]
			var object_atlas_coords = chunk.tiles[1][index]
			var plant_atlas_coords = chunk.tiles[2][index]

			var tile_pos := Vector2i(
				chunk_origin.x + x,
				chunk_origin.y + y
			)

			set_cell(
				tile_pos,
				tile_map_id,
				atlas_coords
			)

			if object_atlas_coords != null:
				#print("made signage")
				object.set_cell(
					tile_pos,
					2,
					object_atlas_coords
				)

			if plant_atlas_coords != null:
				#print("made plantage")
				plants.set_cell(
					tile_pos,
					3,
					plant_atlas_coords
				)

			if chunk.bonfires[index] != null:
				var bonfire_pos: Vector2i = tile_to_world_pos(tile_pos)
				var bonfire = load("res://scenes/bonfire.tscn").instantiate()

				bonfire.position = bonfire_pos + Vector2i(16,16)

				add_child(bonfire)
				if chunk.bonfires[index]:
					bonfire.make_lit()

				drawn_bonfires[bonfire_pos] = bonfire

	drawn_chunks[chunk_pos] = chunk


func unload_chunk(chunk_pos: Vector2i) -> void:
	var chunk_origin := chunk_pos * chunk_size

	for y in range(chunk_size):
		for x in range(chunk_size):
			var tile_pos := Vector2i(
				chunk_origin.x + x,
				chunk_origin.y + y
			)

			erase_cell(tile_pos)
			object.erase_cell(tile_pos)

			var bonfire_pos: Vector2i = tile_to_world_pos(tile_pos)
			if drawn_bonfires.has(bonfire_pos):
				var chunk: Chunk = drawn_chunks[chunk_pos]
				chunk.bonfires[x + y * chunk_size] = drawn_bonfires[bonfire_pos].bonfire_lit

				drawn_bonfires[bonfire_pos].queue_free()

	drawn_chunks.erase(chunk_pos)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return (
		object.get_cell_source_id(coords) != -1
		or plants.get_cell_source_id(coords) != -1
	)


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if (
		object.get_cell_source_id(coords) != -1
		or plants.get_cell_source_id(coords) != -1
	):
		tile_data.set_navigation_polygon(0, null)
