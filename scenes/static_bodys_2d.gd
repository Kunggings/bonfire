extends StaticBody2D

var holder = null

func set_held(player):
	holder = player
	
func release():
	holder = null
