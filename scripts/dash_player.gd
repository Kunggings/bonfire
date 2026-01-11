extends State
class_name Dash

@export var return_state: State
@export var death:State
@export var dash_speed : float = 300.0
@export var dash_duration : float = 0.15
@export var health_cost : float = 20
var health_drain : float = 0

@onready var dash_timer: Timer = $DashTimer


func Enter():
	owner.move_speed = dash_speed
	owner.health_drain = health_drain
	owner.current_health -= health_cost

	dash_timer.wait_time = dash_duration
	dash_timer.start()

func Physics_Update(_delta) -> void:
		
	owner.animation.play("Dash")

func _ready():
	dash_timer.timeout.connect(_on_dash_timeout)

func _on_dash_timeout():
	Transitioned.emit(self, return_state.name)

	if owner.current_health <= 0.0:
			Transitioned.emit(self, death.name)	
