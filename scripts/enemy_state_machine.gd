extends CharacterBody2D

@export var target: CharacterBody2D
@onready var state_machine = $StateMachine
@onready var detection_area: Area2D = $DetectionArea
@onready var line_of_sight: RayCast2D = $LineOfSight
var target_is_visible: bool = false
var target_in_area: bool = false

func _ready():
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	

func _physics_process(_delta: float) -> void:
	
	if target_in_area:
		line_of_sight.target_position = line_of_sight.to_local(target.global_position)
		line_of_sight.force_raycast_update()
		
		if line_of_sight.is_colliding():
			if line_of_sight.get_collider() == target:
				target_is_visible = true
			else:
				target_is_visible = false
	
	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	if body == target:
		target_in_area = true

func _on_body_exited(body: Node) -> void:
	if body == target:
		target_in_area = false
		target_is_visible = false
