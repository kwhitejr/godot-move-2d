class_name WalkComponent
extends AbstractMoveComponent


@export var horizontal_speed : float = 100.0

signal char_walk

func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	var direction := 0.0
	
	if (Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right")):
		direction = Input.get_axis("walk_left", "walk_right")
		
		# Given character is on ground + not crouching
		# When left or right input is applied
		# Then character is walking
		# TODO: how to decouple this from "crouch"
		if body.is_on_floor() and not Input.is_action_pressed("crouch"):
			# Hack to remediate bad body.is_on_floor() value on first jump frame
			if (body.velocity.y >= 0):
				char_walk.emit()
	
	# Regardless of walking state, horizontal movement is always applied
	# so that air movement and control is enabled.
	body.velocity.x = direction * horizontal_speed
	
	if direction:
		body.velocity.x = direction * horizontal_speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, horizontal_speed)
