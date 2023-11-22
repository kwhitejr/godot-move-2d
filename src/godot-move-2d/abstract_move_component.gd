class_name AbstractMoveComponent
extends Node

signal char_visualize_feature_enable(color: Color)
signal char_visualize_feature_disable

func _ready() -> void:
	add_to_group("move_components")
	var body : CharacterBody2D = get_parent()
	handle_ready(body)

## Called in _ready()
## Can be implemented without overriding base class _ready() functionality
func handle_ready(body: CharacterBody2D) -> void:
	pass

## Returns boolean indicating whether the action can be performed.
## Override for custom move conditions.
## @example: res://demos/celeste-clone/jump_component_override.gd
func can_do_move(body: CharacterBody2D) -> bool:
	return true

# Called in CharacterBody2D._input()
func handle_input_event(event : InputEvent, body: CharacterBody2D) -> void:
	pass

# Called in CharacterBody2D._process()
func handle_process(delta: float, body: CharacterBody2D) -> void:
	pass

# Called in CharacterBody2D._physics_process()
func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	pass
