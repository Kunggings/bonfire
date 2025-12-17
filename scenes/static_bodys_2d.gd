extends StaticBody2D

func pickupSound():
	$PickupAudio.play()
	#$LampLight.shadow_enabled(false)
	
func putdownSound():
	$PutdownAudio.play()
	#$LampLight.shadow_enabled(false)
