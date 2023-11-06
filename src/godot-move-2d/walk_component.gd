class_name WalkComponent
extends Node

@export var walk_speed : float = 100.0

# could simplify to just char_walk(is_on_floor: bool, x_velocity: float)
signal char_walk
signal char_walk_left
signal char_walk_right

func handle_move(body: CharacterBody2D) -> void:
	var direction := 0.0
	
	if Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		direction = Input.get_axis("walk_left", "walk_right")
		char_walk.emit(body)
	
	body.velocity.x = direction * walk_speed
	
	if direction:
		body.velocity.x = direction * walk_speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, walk_speed)
