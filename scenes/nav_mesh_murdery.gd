extends TileMapLayer

@onready var object: TileMapLayer = $"../Layer Tree"


var object_cells: Array[Vector2i] = []

func _ready():
 
	object_cells.clear()
	for cell in object.get_used_cells():
		object_cells.append(cell)
	print("Object layer used cells:", object_cells)
 
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	print("Hello")
	return coords in object_cells
 
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in object_cells:
	 
		tile_data.set_navigation_polygon(0, null)
		print("Removed navigation polygon at:", coords)
		
