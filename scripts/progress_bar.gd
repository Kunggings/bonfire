extends TextureProgressBar

@export var player: NodePath

var player_ref

func _ready() -> void:
	player_ref = get_node(player)
	max_value = 100


func _physics_process(_delta: float) -> void:
	if player_ref:
		value = float(player_ref.current_health) / float(player_ref.max_health) * 100.0
