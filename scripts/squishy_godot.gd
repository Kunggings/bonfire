extends "res://scripts/item.gd"

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	point_light_2d.enabled = false

func pickupSound():
	if pickup_sound:
		pickup_audio.stream = pickup_sound
		pickup_audio.play()

	point_light_2d.enabled = true


func putdownSound():
	if putdown_sound:
		putdown_audio.stream = putdown_sound
		putdown_audio.play()

	point_light_2d.enabled = false
