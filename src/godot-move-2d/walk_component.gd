class_name WalkComponent
extends AbstractMoveComponent

@export var walk_speed : float = 100.0

signal char_walk

func detect_move(delta: float, body: CharacterBody2D):
	pass
	
func handle_move(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	var direction := 0.0
	
	if Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		direction = Input.get_axis("walk_left", "walk_right")
		char_walk.emit(body)
	
	body.velocity.x = direction * walk_speed
	
	if direction:
		body.velocity.x = direction * walk_speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, walk_speed)
