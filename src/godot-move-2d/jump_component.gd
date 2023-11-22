class_name JumpComponent
extends AbstractMoveComponent


## Configuration settings for the Jump movement.
@export_group("Jump Configuration")
## The height of the jump.
@export var jump_height : float = 30
## The amount of time in seconds to reach the apex of the jump.
@export var jump_time_to_apex : float = 0.5
## The amount of time in seconds to descend the distance of the jump_height.
@export var jump_time_to_descent : float = 0.25
## The amount of air jumps allowed. Zero means air jumps are disabled. 
@export var air_jumps_total : int = 2
## Whether "coyote time" is enabled. 
## "Coyote time" is the period during which, after leaving the ground, a character may still jump.
@export var is_coyote_time_enabled : bool = true
## The duration of coyote time in seconds.
@export var coyote_time_duration_secs : float = 0.1
## Whether "jump buffer" is enabled. 
## "Jump buffer" is the period during which, before hitting the ground, a player's jump input will register as if player was on the ground.
@export var is_jump_buffer_enabled : bool = true
@export var jump_buffer_duration_secs : float = 0.2

## Configuration settings for visualizing the Jump movement.
@export_group("Jump Feature Visualization")
@export var is_visualize_coyote_time_enabled : bool = false
@export var coyote_time_feature_color : Color = Color(Constants.FeatureVisualizationColors.BLUE)
@export var is_visualize_jump_buffer_enabled : bool = false
@export var jump_buffer_feature_color : Color = Color(Constants.FeatureVisualizationColors.PINK)

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_apex) * -1.0
var jump_ascend_gravity : float = ((-2.0 * jump_height) / (jump_time_to_apex * jump_time_to_apex)) * -1.0
var jump_descend_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
var air_jumps_current : int = air_jumps_total
var is_jumping : bool = false

var coyote_timer := Timer.new()
var jump_buffer_timer := Timer.new()

## Fired when the character jump ascension begins.
signal char_jump_ascend
## Fired when the character reaches the jump apex.
signal char_jump_apex
## Fired when the character jump descension begins.
signal char_jump_descend
## Fired when the character lands on ground during a jump.
signal char_jump_landed
## Fired when the character performs an air jump.
signal char_jump_air

func handle_ready(body: CharacterBody2D):
	add_child(coyote_timer)
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(jump_buffer_timer)
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.timeout.connect(_on_jump_buffer_timer_timeout)

func handle_input_event(event : InputEvent, body : CharacterBody2D) -> void:
	if is_jump_buffer_enabled:
		_handle_jump_buffer(body)
	
	if event.is_action_pressed("jump"):
		if is_jump_buffer_enabled:
			_start_jump_buffer_timer()
		if can_do_move(body):
			_jump(body)
		if _can_jump_air(body, is_jumping, air_jumps_current):
			_jump_air(body)

func handle_process(delta: float, body: CharacterBody2D):
	if not body.is_on_floor() and not is_jumping:
		_start_coyote_timer()
		
func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2):
	if _should_jump_apex(body, is_jumping, previous_velocity):
		_jump_apex()
		
	if _should_jump_descend(body, is_jumping, previous_velocity):
		_jump_descend()
		
	if _should_jump_land(body, is_jumping, previous_velocity):
		_jump_land()

## Returns a float representing the gravity during a jump.
func get_jump_gravity(body : CharacterBody2D) -> float:
	return jump_ascend_gravity if body.velocity.y < 0.0 else jump_descend_gravity

## Returns a boolean representing whether the character can jump.
func can_do_move(body: CharacterBody2D) -> bool:
	if is_coyote_time_enabled and not body.is_on_floor():
		return coyote_timer.get_time_left() > 0
	return body.is_on_floor()

## Encapsulates logic for a Jump movement.
func _jump(body: CharacterBody2D) -> void:
	air_jumps_current = air_jumps_total
	body.velocity.y = jump_velocity
	is_jumping = true
	char_jump_ascend.emit()

## Returns a boolean representing whether the character can air jump.
func _can_jump_air(body: CharacterBody2D, is_jumping: bool, remaining_air_jumps: int) -> bool:
	return remaining_air_jumps > 0 and is_jumping and not body.is_on_floor()

## Encapsulates logic for an air jump movement.
func _jump_air(body: CharacterBody2D) -> void:
	air_jumps_current -= 1
	body.velocity.y = jump_velocity
	is_jumping = true
	char_jump_air.emit()

func _should_jump_land(body: CharacterBody2D, _is_jumping: bool, previous_velocity: Vector2) -> bool:
	return _is_jumping and is_zero_approx(previous_velocity.y) and body.is_on_floor()

func _jump_land() -> void:
	is_jumping = false
	char_jump_landed.emit()
	
func _should_jump_descend(body: CharacterBody2D, _is_jumping: bool, previous_velocity: Vector2) -> bool:
	return _is_jumping and is_zero_approx(previous_velocity.y) and body.velocity.y > 0 and not body.is_on_floor()
	
func _jump_descend() -> void:
	char_jump_descend.emit()
	
func _should_jump_apex(body: CharacterBody2D, _is_jumping: bool, previous_velocity: Vector2) -> bool:
	return _is_jumping and previous_velocity.y < 0 and is_zero_approx(body.velocity.y) and not body.is_on_floor()

func _jump_apex() -> void:
	char_jump_apex.emit()

func _start_coyote_timer() -> void:
	coyote_timer.start(coyote_time_duration_secs)
	if is_visualize_coyote_time_enabled:
		char_visualize_feature_enable.emit(coyote_time_feature_color)
	
func _start_jump_buffer_timer() -> void:
	jump_buffer_timer.start(jump_buffer_duration_secs)
	if is_visualize_jump_buffer_enabled:
		char_visualize_feature_enable.emit(jump_buffer_feature_color)

## Encapsulates logic for jump buffer.
func _handle_jump_buffer(body: CharacterBody2D) -> void:
	if jump_buffer_timer.get_time_left() > 0 and can_do_move(body):
		jump_buffer_timer.stop()
		char_visualize_feature_disable.emit()
		_jump(body)
		
func _on_coyote_timer_timeout() -> void:
	_handle_timer_end()
	
func _on_jump_buffer_timer_timeout() -> void:
	_handle_timer_end()

func _handle_timer_end() -> void:
	char_visualize_feature_disable.emit()
