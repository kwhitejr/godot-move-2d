class_name Pickup
extends Area2D


func _on_body_entered(body):
	if body is TestCharacter:
		body.collect(self)
		queue_free()
