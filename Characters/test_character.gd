extends CharacterBody2D


# Defaults
@export var default_descend_gravity : float = 500.0

# Configure Moves
@onready var jump_component : JumpComponent = get_node("JumpComponent")
@onready var walk_component : WalkComponent = get_node("WalkComponent")
@onready var crouch_component : CrouchComponent = get_node("CrouchComponent")
@onready var dash_component : DashComponent = get_node("DashComponent")

# Helpers
@onready var previous_velocity : Vector2 = Vector2.ZERO
@onready var previous_direction : float = 0.0
@onready var is_gravity_locked : bool = false

# Idle signal(s)
signal char_idle_stand
signal char_face_direction

func _process(delta) -> void:
	jump_component.detect_move(self)
	dash_component.detect_move(self)

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	velocity.y += get_gravity() * delta
	
	# Handle moves
	walk_component.handle_move(self)
	jump_component.handle_move(self, previous_velocity)
	crouch_component.handle_move(self)
	dash_component.handle_move(self, delta)

	var direction = Input.get_axis("walk_left", "walk_right")
	if not direction == previous_direction and not direction == 0.0:
		char_face_direction.emit(direction)
	
	if not Input.is_anything_pressed():
		char_idle_stand.emit(self)

	move_and_slide()

func get_gravity() -> float:
	if jump_component:
		return jump_component.jump_ascend_gravity if velocity.y < 0.0 else jump_component.jump_descend_gravity
	else:
		return default_descend_gravity


