extends ProgressBar

@export var player: NodePath  # drag your Player node here in the editor

var player_ref

func _ready() -> void:
	player_ref = get_node(player)
	max_value = 100  # or use player_ref.max_health if it exists


func _process(delta: float) -> void:
	if player_ref:
		# Update bar to a percentage
		value = float(player_ref.current_health) / float(player_ref.max_health) * 100.0
