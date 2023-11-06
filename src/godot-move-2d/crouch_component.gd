class_name CrouchComponent
extends Node

# Crouch signal(s)
signal char_idle_crouch

func handle_move(body: CharacterBody2D) -> void:
	# Handle crouch
	if Input.is_action_pressed("crouch") and body.is_on_floor():
		char_idle_crouch.emit()
