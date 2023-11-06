class_name AbstractMoveComponent
extends Node

signal char_visualize_feature_enable
signal char_visualize_feature_disable

# Call in CharacterBody2D._process()
func detect_move(delta: float, body: CharacterBody2D) -> void:
	push_warning("NOT IMPLEMENTED: MoveComponent.detect_move()")

# Call in CharacterBody2D._physics_process()
func handle_move(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	push_warning("NOT IMPLEMENTED: MoveComponent.handle_move()")
