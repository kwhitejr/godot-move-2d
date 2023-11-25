class_name TestCharacter
extends CharacterBody2D


const utils = preload("res://src/libs/utils.gd")

# Defaults
@export var default_descend_gravity : float = 500.0

@onready var move_components = utils.get_typed_children(self, AbstractMoveComponent)
# TODO: get jump gravity without specific reference to JumpComponent
@onready var jump_component : JumpComponent = get_node("JumpComponent")

# Helpers
@onready var previous_velocity : Vector2 = Vector2.ZERO
@onready var previous_direction : float
@onready var is_gravity_disabled : bool = false

signal char_idle_stand
signal char_face_direction
signal char_collect_pickup(pickup : Pickup)

func _input(event : InputEvent) -> void:
	# Handle event inputs
	for move_component in move_components:
		move_component.handle_input_event(event, self)

func _process(delta: float) -> void:
	for move_component in move_components:
		move_component.handle_process(delta, self)

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	velocity.y += _get_gravity(self) * delta
	
	# Handle polling inputs
	for move_component in move_components:
		move_component.handle_physics_process(delta, self, previous_velocity)

	_handle_direction()

	var is_idle := not Input.is_anything_pressed() and self.is_on_floor() and is_zero_approx(self.velocity.x)
	if is_idle:
		char_idle_stand.emit()

	move_and_slide()

func _handle_direction() -> void:
	var direction = Input.get_axis("walk_left", "walk_right")
	if (previous_direction != direction) and (direction != 0):
		char_face_direction.emit(direction)
		direction = previous_direction

func _get_gravity(body: CharacterBody2D) -> float:
	if is_gravity_disabled:
		return 0.0
	if jump_component:
		return jump_component.get_jump_gravity(body)
	else:
		return default_descend_gravity

func collect(pickup : Pickup):
	char_collect_pickup.emit(pickup)
