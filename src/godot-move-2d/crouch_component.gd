class_name CrouchComponent
extends AbstractMoveComponent


signal char_idle_crouch

func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	if Input.is_action_pressed("crouch") and body.is_on_floor():
		char_idle_crouch.emit()
