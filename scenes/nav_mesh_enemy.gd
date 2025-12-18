extends CharacterBody2D

@export var speed: float = 30.0
@export var target_path: NodePath

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var target: Node2D = get_node(target_path)

func _ready():
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 4.0
	agent.max_speed = speed

func _physics_process(delta):
	if not is_instance_valid(target):
		return

	# Set destination
	agent.target_position = target.global_position

	# Get next path point
	var next_pos := agent.get_next_path_position()
	var direction := (next_pos - global_position).normalized()

	velocity = direction * speed
	move_and_slide()
