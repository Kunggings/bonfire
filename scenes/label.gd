extends Label

@onready var state_machine = $"../StateMachine"

func _process(_delta):
	if state_machine.current_state:
		text = state_machine.current_state.name
