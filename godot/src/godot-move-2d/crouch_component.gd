class_name CrouchComponent
extends AbstractMoveComponent


@export var crouch_walk_speed : float = 60.0

signal char_crouch_idle
signal char_crouch_end
signal char_crouch_walk

func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	var _is_crouching := Input.is_action_pressed("crouch") and body.is_on_floor() and (body.velocity.y >= 0)
	
	if _is_crouching and (Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right")):
		var direction = Input.get_axis("walk_left", "walk_right")
		
		char_crouch_walk.emit()
		
		body.velocity.x = direction * crouch_walk_speed
	
		if direction:
			body.velocity.x = direction * crouch_walk_speed
		else:
			body.velocity.x = move_toward(body.velocity.x, 0, crouch_walk_speed)
		
	elif _is_crouching:
		char_crouch_idle.emit()
		
	if Input.is_action_just_released("crouch"):
		char_crouch_end.emit()
