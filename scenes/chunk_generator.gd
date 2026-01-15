extends Node

@onready var player: Player = $"../Player"

@onready var floor: TileMapLayer = $Floor

@export var tile_size: int = 32
@export var chunk_size: int = 10

@export var floor_noise: FastNoiseLite

@export var floor_source_id: int = 0
@export var grass_atlas: Vector2i
@export var stone_atlas: Vector2i

@export var floor_threshold: float = -0.2

func _ready() -> void:

	load_chunk(0, 0)

func load_chunk(chunk_x: int, chunk_y: int) -> void:
	floor.clear()

	var half = chunk_size / 2.0

	for x in range(-half, half):
		for y in range(-half, half):

			var world_x := x + chunk_x * chunk_size
			var world_y := y + chunk_y * chunk_size

			var floor_noise_val = floor_noise.get_noise_2d(world_x, world_y)

			if floor_noise_val < floor_threshold:
				floor.set_cell(
					Vector2i(x, y),
					floor_source_id,
					stone_atlas
				)
			else:
				floor.set_cell(
					Vector2i(x, y),
					floor_source_id,
					grass_atlas
				)
