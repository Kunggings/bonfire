extends Node
class_name State

@warning_ignore("unused_signal") #George said it was fine 
signal Transitioned(state, new_state_name)


func Enter():
	pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass
