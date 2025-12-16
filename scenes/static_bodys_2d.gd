extends StaticBody2D

func pickupSound():
	$PickupAudio.play()
	
func putdownSound():
	$PutdownAudio.play()
