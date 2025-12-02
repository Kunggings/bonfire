extends Area2D

@export var lit_texture := preload("res://bonfire.png")

func _on_body_entered(body: Node2D) -> void:
	print("Bonfire")
	$Sprite.texture = lit_texture
	set_deferred("monitoring", false)
