extends CharacterBody2D

@export var target_body: CharacterBody2D
var target: Vector2 = Vector2.ZERO
@onready var state_machine = $StateMachine
@onready var detection_area: Area2D = $DetectionArea
@onready var line_of_sight: RayCast2D = $LineOfSight
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var target_is_visible: bool = false
var target_in_area: bool = false

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	
	if target_in_area:
		line_of_sight.target_position = line_of_sight.to_local(target_body.global_position)
		line_of_sight.force_raycast_update()
		
		if line_of_sight.is_colliding():
			if line_of_sight.get_collider() == target_body:
				target_is_visible = true
			else:
				target_is_visible = false
	
	nav_agent.target_position = target
	var next_point := nav_agent.get_next_path_position()
	var direction := (next_point - global_position).normalized()
	velocity = direction * state_machine.current_state.move_speed
	
	if velocity.x < 0:
		animation.flip_h = true
	elif velocity.x > 0:
		animation.flip_h = false
	
	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	if body == target_body:
		target_in_area = true

func _on_body_exited(body: Node) -> void:
	if body == target_body:
		target_in_area = false
		target_is_visible = false
