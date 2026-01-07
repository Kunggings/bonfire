extends CharacterBody2D

@export var target: CharacterBody2D
@onready var state_machine = $StateMachine

func _ready():
	pass



func _physics_process(_delta: float) -> void:
	move_and_slide()
	
