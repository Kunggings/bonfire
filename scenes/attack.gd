extends State

@export var move_speed := 10.0
@export var idle: State
@export var follow: State
@export var attack_damage : float = 20.0
@export var attack_range : float = 25.0
@export var attack_duration: float = 1.5
@onready var attack_timer: Timer = $AttackTimer


var wander_location : Vector2

func _ready():
	attack_timer.timeout.connect(_on_attack_timeout)

func Enter() -> void:
	
	attack_timer.wait_time = attack_duration
	attack_timer.start()
	
	owner.target_body.current_health -= attack_damage 

func Physics_Update(_delta: float) -> void:
	
	owner.animation.play("Attack")
	
	
func _on_attack_timeout():
	
	if owner.target_is_visible == false:
		Transitioned.emit(self, idle.name)
	
	if owner.target_is_visible == true:
		Transitioned.emit(self, follow.name)
		
