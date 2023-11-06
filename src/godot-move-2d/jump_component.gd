class_name JumpComponent
extends Node


@export var jump_height : float = 30
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.25

@export var air_jumps_total : int = 2

@export var is_coyote_time_enabled : bool = true
@export var coyote_time_duration_secs : float = 0.1
@export var is_visualize_coyote_time_enabled : bool = true
@export var coyote_time_feature_color : Color = Color(Constants.FeatureVisualizationColors.BLUE)

@export var is_jump_buffer_enabled : bool = true
@export var jump_buffer_duration_secs : float = 0.2
@export var is_visualize_jump_buffer_enabled : bool = true
@export var jump_buffer_feature_color : Color = Color(Constants.FeatureVisualizationColors.PINK)


var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_ascend_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var jump_descend_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
var air_jumps_current : int = air_jumps_total
var is_jumping : bool = false

var coyote_timer := Timer.new()
var jump_buffer_timer := Timer.new()

signal char_jump_ascend
signal char_jump_apex
signal char_jump_descend
signal char_jump_landed
signal char_jump_air
signal char_visualize_feature_enable
signal char_visualize_feature_disable

func _ready():
	add_child(coyote_timer)
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(jump_buffer_timer)
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.timeout.connect(_on_jump_buffer_timer_timeout)

func detect_move(body: CharacterBody2D):
	if not body.is_on_floor() and not is_jumping:
		_start_coyote_timer()

func handle_move(body: CharacterBody2D, previous_velocity: Vector2):
	if is_jump_buffer_enabled:
		_handle_jump_buffer(body)
	
	if _should_jump_apex(body, is_jumping, previous_velocity):
		_jump_apex()
		
	if _should_jump_descend(body, is_jumping, previous_velocity):
		_jump_descend()
		
	if _should_jump_land(body, is_jumping, previous_velocity):
		_jump_land()
	
	if Input.is_action_just_pressed("jump"):
		if is_jump_buffer_enabled:
			_start_jump_buffer_timer()
		if _should_jump(body):
			jump(body)
		if _should_jump_air(body, is_jumping, air_jumps_current):
			jump_air(body)

func _should_jump(body: CharacterBody2D) -> bool:
	if is_coyote_time_enabled and not body.is_on_floor():
		return coyote_timer.get_time_left() > 0
	return body.is_on_floor()

func jump(body: CharacterBody2D) -> void:
	air_jumps_current = air_jumps_total
	body.velocity.y = jump_velocity
	is_jumping = true
	char_jump_ascend.emit()

func _should_jump_air(body: CharacterBody2D, is_jumping: bool, remaining_air_jumps: int) -> bool:
	return remaining_air_jumps > 0 and is_jumping and not body.is_on_floor()
	
func jump_air(body: CharacterBody2D) -> void:
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

func _handle_jump_buffer(body: CharacterBody2D) -> void:
	if jump_buffer_timer.get_time_left() > 0 and _should_jump(body):
		jump_buffer_timer.stop()
		char_visualize_feature_disable.emit()
		jump(body)
		
func _on_coyote_timer_timeout() -> void:
	_handle_timer_end()
	
func _on_jump_buffer_timer_timeout() -> void:
	_handle_timer_end()

func _handle_timer_end() -> void:
	char_visualize_feature_disable.emit()
