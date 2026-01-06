extends StaticBody2D

@export var pickup_sound: AudioStream
@export var putdown_sound: AudioStream

@onready var pickup_audio: AudioStreamPlayer2D = $PickupAudio
@onready var putdown_audio: AudioStreamPlayer2D = $PutdownAudio

func pickupSound():
	if pickup_sound:
		pickup_audio.stream = pickup_sound
		pickup_audio.play()

func putdownSound():
	if putdown_sound:
		putdown_audio.stream = putdown_sound
		putdown_audio.play()
