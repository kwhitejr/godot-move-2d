extends CharacterBody2D

# Configure horizontal movement
@export var move_speed : float = 200.0

# Configure Jump
@onready var jump_component : JumpComponent = get_node("JumpComponent")
#@export var air_jumps_total : int = 2
#@export var jump_height : float = 30
#@export var jump_time_to_peak : float = 0.5
#@export var jump_time_to_descent : float = 0.25
#
#@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
#@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
#
#@onready var air_jumps_current : int = air_jumps_total
@onready var previous_velocity : Vector2 = Vector2.ZERO
#@onready var is_jumping : bool = false

# Horizontal movement signals
signal char_idle_stand
signal char_move_left
signal char_move_right

# Crouch signals
signal char_idle_crouch

# Jump signals
#signal char_jump_ascend
#signal char_jump_apex
#signal char_jump_descend
#signal char_jump_landed
#signal char_jump_air

func _physics_process(delta) -> void:
	previous_velocity = velocity
	velocity.y += get_gravity() * delta
	velocity.x = get_horizontal_velocity() * move_speed
	
	# Handle jump
	jump_component.do_move(self, previous_velocity)
#	if is_jumping:
#		if previous_velocity.y < 0 and is_zero_approx(velocity.y) and not is_on_floor():
#			char_jump_apex.emit()
#
#		if is_zero_approx(previous_velocity.y) and velocity.y > 0 and not is_on_floor():
#			char_jump_descend.emit()
#
#		if is_zero_approx(previous_velocity.y) and is_on_floor():
#			jump_land()
#			char_jump_landed.emit() 
#
#	if Input.is_action_just_pressed("jump"):
#		if is_on_floor():
#			jump()
#			char_jump_ascend.emit()
#		if air_jumps_current > 0 and not is_on_floor():
#			jump_air()
#			char_jump_air.emit()
			
	# Handle crouch
	if Input.is_action_pressed("crouch"):
		if is_on_floor():
			char_idle_crouch.emit()
	if not Input.is_anything_pressed():
		char_idle_stand.emit(is_on_floor())

	# Handle horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	move_and_slide()

func get_gravity() -> float:
	return jump_component.jump_gravity if velocity.y < 0.0 else jump_component.fall_gravity
#	return JumpComponent._Get("jump_gravity") if velocity.y < 0.0 else JumpComponent._Get("fall_gravity")

#func jump() -> void:
#	air_jumps_current = air_jumps_total
#	velocity.y = jump_velocity
#	is_jumping = true
#
#func jump_air() -> void:
#	air_jumps_current -= 1
#	velocity.y = jump_velocity
#	is_jumping = true
#
#func jump_land() -> void:
#	is_jumping = false

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("move_left"):
		horizontal -= 1.0
		char_move_left.emit(is_on_floor())
	if Input.is_action_pressed("move_right"):
		horizontal += 1.0
		char_move_right.emit(is_on_floor())
	
	return horizontal
