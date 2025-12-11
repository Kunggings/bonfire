extends Node

@export var bonfire_scene: PackedScene
@export var bonfire_count: int = 10
@export var map_size: int = 300

func _ready():
	spawn_bonfires()

func spawn_bonfires():
	if bonfire_scene == null:
		push_error("Bonfire scene not assigned!")
		return

	for i in range(bonfire_count):
		var bonfire = bonfire_scene.instantiate()
		
		bonfire.position = Vector2(
			randi_range(-map_size/2, map_size/2),
			randi_range(-map_size/2, map_size/2)
		)

		add_child(bonfire)
