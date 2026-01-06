extends TileMapLayer

@onready var object: TileMapLayer = $"../Object"

@export var map_size := 100
@export var floor_noise_texture: NoiseTexture2D
@export var object_noise_texture: NoiseTexture2D

@export var floor_threshold: float = 0    
@export var object_threshold: float = 0.5

var floor_noise: Noise
var object_noise: Noise

var floor_source_id := 1
var object_source_id := 2

var grass_atlas := Vector2i(0,0)
var stone_atlas := Vector2i(0,4)
var sign_atlas := Vector2i(3,7)

var object_cells: Array[Vector2i] = []

func _ready():
	
	floor_noise_texture.noise.seed = randi()
	floor_noise = floor_noise_texture.noise
	
	object_noise_texture.noise.seed = randi()
	object_noise = object_noise_texture.noise
	
	generate_world()
	
 
	object_cells.clear()
	for cell in object.get_used_cells():
		object_cells.append(cell)
	#print("Object layer used cells:", object_cells)
 
func generate_world():
	
	for x in range(-map_size / 2, map_size / 2):
		for y in range(-map_size / 2, map_size / 2):

			#print("placing tile at ", x, ", ", y)
			var floor_noise_val := floor_noise.get_noise_2d(x, y)
			var object_noise_val := object_noise.get_noise_2d(x,y)
			
			if floor_noise_val > -1:
				self.set_cell(
					Vector2i(x, y),
					floor_source_id,
					grass_atlas
			)

			if floor_noise_val < floor_threshold:
				self.set_cell(
					Vector2i(x, y),
					floor_source_id,
					stone_atlas
				)
			if object_noise_val > object_threshold:
				object.set_cell(
					Vector2i(x, y),
					object_source_id,
					sign_atlas
				)
			

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return coords in object_cells
 
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in object_cells:
	 
		tile_data.set_navigation_polygon(0, null)
		#print("Removed navigation polygon at:", coords)

		
