extends State

@export var idle: State
@export var dash: State
@export var move_speed : float = 100.0
@export var health_drain : float = 2.0

func Enter() -> void:
	owner.move_speed = move_speed
	owner.health_drain = health_drain

func Exit() -> void:

	pass

func Physics_Update(_delta: float) -> void:
	
	if owner.velocity.x < 0:
		owner.animation.flip_h = true
	elif owner.velocity.x > 0:
		owner.animation.flip_h = false

	owner.animation.play("Sprint")

	if not Input.is_action_pressed("Sprint"): 
			Transitioned.emit(self, idle.name)
	
	if Input.is_action_just_pressed("Dash") and owner.current_health >= 1.5 * dash.health_cost:
		Transitioned.emit(self, dash.name)
