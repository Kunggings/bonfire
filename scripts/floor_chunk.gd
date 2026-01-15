extends TileMapLayer

@export var chunk_size: int = 2
@export var floor_noise: FastNoiseLite

@export var source_id: int = 0
@export var grass_atlas: Vector2i
@export var stone_atlas: Vector2i

@export var floor_threshold: float = -0.2

@onready var player: Player = $"../Player"

var generated_chunks: Dictionary = {}
var last_player_chunk: Vector2i


func _ready() -> void:
	last_player_chunk = get_player_chunk()
	generate_chunks_around_player() 


func _physics_process(_delta: float) -> void:
	var current_chunk := get_player_chunk()
	if current_chunk != last_player_chunk:
		last_player_chunk = current_chunk
		generate_chunks_around_player()


func get_player_chunk() -> Vector2i:
	var tile_pos := local_to_map(player.global_position)
	return Vector2i(
		floor(tile_pos.x / float(chunk_size)),
		floor(tile_pos.y / float(chunk_size))
	)


func generate_chunks_around_player() -> void:
	var center_chunk := get_player_chunk()

	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var chunk := center_chunk + Vector2i(dx, dy)

			if generated_chunks.has(chunk):
				continue

			generate_chunk(chunk.x, chunk.y)
			generated_chunks[chunk] = true


func generate_chunk(chunk_x: int, chunk_y: int) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			var world_x := x + chunk_x * chunk_size
			var world_y := y + chunk_y * chunk_size
			var tile_pos := Vector2i(world_x, world_y)

			var noise_val := floor_noise.get_noise_2d(world_x, world_y)

			if noise_val < floor_threshold:
				set_cell(tile_pos, source_id, stone_atlas)
			else:
				set_cell(tile_pos, source_id, grass_atlas)
