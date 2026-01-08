extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready():
	
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		current_state = initial_state
		current_state.Enter()


func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name)
	if not new_state:
		return

	#print("current State", current_state)
	current_state.Exit()
	current_state = new_state
	current_state.Enter()
	#print("new State", current_state)
