extends State

@export var move_speed := 20.0
@export var idle_state: State
@export var follow_state: State
@export var wander_state: State
@export_range(0.0, 1.0 , 0.01) var wander_percentage = 0.5

var wander_location : Vector2

@onready var nav_agent: NavigationAgent2D = $"../../NavigationAgent2D"

@onready var detection_area: Area2D = $"../../DetectionArea"

func Enter() -> void:
	
	owner.target = generate_wander_target_map()

func Physics_Update(_delta: float) -> void:
	
	owner.animate.play("Walk")
	
	if owner.target.distance_to(owner.global_position) <= 20 :
		if randf() >= wander_percentage:
			Transitioned.emit(self, wander_state.name)
		else:
			Transitioned.emit(self, idle_state.name)
	
	if owner.target_is_visible == true:
		Transitioned.emit(self, follow_state.name)

func generate_wander_target_map() -> Vector2:
	var shape = detection_area.get_node("CollisionShape2D").shape
	var radius = shape.radius

	for i in 10:
		var angle = randf() * TAU
		var distance = sqrt(randf()) * radius
		var offset = Vector2(cos(angle), sin(angle)) * distance
		var candidate = detection_area.global_position + offset

		nav_agent.target_position = candidate
#
		if nav_agent.is_target_reachable():
			return nav_agent.get_final_position()

	return owner.global_position
