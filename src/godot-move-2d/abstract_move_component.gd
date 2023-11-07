class_name AbstractMoveComponent
extends Node

signal char_visualize_feature_enable(color: Color)
signal char_visualize_feature_disable

func _ready() -> void:
	add_to_group("move_components")
	ready_move()

func ready_move() -> void:
	pass

# Called in CharacterBody2D._process()
func detect_move(delta: float, body: CharacterBody2D) -> void:
	push_warning("NOT IMPLEMENTED: MoveComponent.detect_move()")

# Called in CharacterBody2D._physics_process()
func handle_move(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	push_warning("NOT IMPLEMENTED: MoveComponent.handle_move()")
