class_name DashComponent
extends AbstractMoveComponent

# Separate duration config from timer
@export var dash_duration : float = 0.25
@export var dash_speed_multiplier : float = 2
@export var dash_cooldown : float = 1.0
@export var is_air_dash_enabled : bool = true

var is_dashing : bool = false
var original_velocity : Vector2 = Vector2()
var dash_timer : float = dash_duration
var cooldown_timer : float = 0.0

signal char_dash_start
signal char_dash_end

func detect_move(delta: float, body: CharacterBody2D) -> void:
	if Input.is_action_just_pressed("dash"):
		if not is_dashing and cooldown_timer <= 0:
			if body.is_on_floor() or is_air_dash_enabled:
				_start_dash(body)

func handle_move(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	if is_dashing:
		dash_timer -= delta
		body.velocity = _get_dash_velocity(body, original_velocity)
		
		if dash_timer <= 0:
			_end_dash(body)
	if cooldown_timer > 0:
		cooldown_timer -= delta

func _start_dash(body: CharacterBody2D) -> void:
#	print("Start Dash")
	original_velocity = body.velocity
	is_dashing = true
	cooldown_timer = dash_cooldown
	
	char_dash_start.emit()
	
func _end_dash(body: CharacterBody2D) -> void:
#	print("End Dash")
	is_dashing = false
	dash_timer = dash_duration
	body.velocity = Vector2()

func _get_dash_velocity(body: CharacterBody2D, original_velocity: Vector2) -> Vector2:
	return original_velocity * dash_speed_multiplier
