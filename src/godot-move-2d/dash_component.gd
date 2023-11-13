class_name DashComponent
extends AbstractMoveComponent


const utils = preload("res://src/libs/utils.gd")

## Directional limitations on the dash movement.
enum DashDirectionType {
	CARDINAL, 	## Dash is limited to Primary Cardinal directions (up, down, left, or right).
	OCTOGONAL, 	## Dash is limited to Primary and Secondary Cardinal directions (up, up-left, left, etc).
	OMNI		## Dash direction is not limited, enjoys 360 degrees.
}

## Configuration settings for the Dash movement.
@export_group("Dash Configuration")
## The configured DashDirectionType
@export var dash_direction_type : DashDirectionType = DashDirectionType.OMNI
## The duration in seconds for the dash. Higher results in longer dash.
@export var dash_duration : float = 0.25
## The velocity of the dash. If you want the dash to feel fast, must be greater than normal speed (e.g. walk_speed)
@export var dash_speed : float = 300
## The number of consecutive dashes before requiring a cooldown. Note: Zero results in buggy behavior. 
@export var dash_amount : int = 2
## The duration in seconds for the dash cooldown. After the cooldown ends, character can dash again. 
@export var dash_cooldown_duration : float = 1.0
## Whether the character can dash when CharacterBody2D.is_on_floor() == false
@export var is_air_dash_enabled : bool = true

## Configuration settings for visualizing the Dash movement.
@export_group("Dash Feature Visualization")
@export var is_visualize_dash_enabled : bool = false
@export var dash_feature_color : Color = Color(Constants.FeatureVisualizationColors.GREEN)
@export var is_visualize_dash_cooldown_enabled : bool = false
@export var dash_cooldown_color : Color = Color(Constants.FeatureVisualizationColors.PURPLE)

var _is_dashing : bool = false
var _original_velocity : Vector2 = Vector2()
var _dash_velocity : Vector2 = Vector2()
var _dash_counter : int = dash_amount

var dash_timer := Timer.new()
var dash_cooldown_timer := Timer.new()

## Fired when the Dash movement starts.
signal char_dash_start
## Fired when the Dash movement ends.
signal char_dash_end

func ready_move(body: CharacterBody2D):
	add_child(dash_timer)
	dash_timer.one_shot = true
	dash_timer.timeout.connect(Callable(_on_dash_timer_timeout).bind(body))
	add_child(dash_cooldown_timer)
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timout)
	
func detect_move(delta: float, body: CharacterBody2D) -> void:
	if Input.is_action_just_pressed("dash"):
		var direction_input : Vector2 = Input.get_vector("left", "right", "up", "down")
		
		if _can_dash(body):
			var _dash_direction := _get_dash_direction(direction_input, dash_direction_type)
			_start_dash(body, _dash_direction)

func handle_move(delta: float, body: CharacterBody2D, previous_velocity: Vector2) -> void:
	if _is_dashing:
		body.velocity = _dash_velocity

## Returns whether the parent CharacterBody2D can perform Dash movement.
func _can_dash(body: CharacterBody2D) -> bool:
	return (dash_cooldown_duration == 0.0 or _dash_counter > 0) and (body.is_on_floor() or is_air_dash_enabled)

## Encapsulates logic for initiating Dash movement.
func _start_dash(body: CharacterBody2D, direction: Vector2) -> void:
	dash_timer.start(dash_duration)
	_is_dashing = true
	_dash_velocity = direction * dash_speed
	_dash_counter -= 1
	char_dash_start.emit()
	if is_visualize_dash_enabled:
		char_visualize_feature_enable.emit(dash_feature_color)

## Encapsulates logic for ending Dash movement.
func _end_dash(body: CharacterBody2D) -> void:
	_is_dashing = false
	body.velocity = Vector2()
	char_dash_end.emit()
	char_visualize_feature_disable.emit()
	
func _on_dash_timer_timeout(body: CharacterBody2D) -> void:
	_end_dash(body)
	dash_cooldown_timer.start(dash_cooldown_duration)
	if is_visualize_dash_cooldown_enabled:
		char_visualize_feature_enable.emit(dash_cooldown_color)

func _on_dash_cooldown_timer_timout() -> void:
	_dash_counter = dash_amount
	if is_visualize_dash_cooldown_enabled:
		char_visualize_feature_disable.emit()

# Returns a Vector2D that indicates the dash direction based on player input.
func _get_dash_direction(input: Vector2, dash_direction_type: DashDirectionType) -> Vector2:
	var segments : float
	match (dash_direction_type):
		DashDirectionType.OMNI:
			segments = 360.0
		DashDirectionType.OCTOGONAL:
			segments = 8.0
		DashDirectionType.CARDINAL:
			segments = 4.0
	return utils.get_rounded_vector(input, segments)
