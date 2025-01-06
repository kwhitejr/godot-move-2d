class_name WallMovementsComponent
extends AbstractMoveComponent


enum WALL_CLING_INPUT_TYPE {
	DIRECTIONAL,	# Player must hold Left or Right in direction of the wall.
	NON_DIRECTIONAL	# Player must hold specified "wall_cling" input.
}

## Configuration settings for the Wall-based movements.
## NOTE: see JumpComponent for wall jump.
@export_group("Wall Movements Configuration")
## Whether wall cling is enabled.
@export var is_wall_cling_enabled : bool = true
@export var wall_cling_input_type : WALL_CLING_INPUT_TYPE = WALL_CLING_INPUT_TYPE.DIRECTIONAL
## The duration in seconds before character will fall or wall slide.
@export var wall_cling_duration_secs : float = 1.0
## Whether wall slide is enabled.
@export var is_wall_slide_enabled : bool = true
## The maximum gravity during a slide (downward velocity).
@export var wall_slide_max_gravity : float = 100
## How quickly the downward velocity scales to maximum (higher is faster).
@export var wall_slide_friction : float = 50
## Whether wall climb is enabled.
@export var is_wall_climb_enabled : bool = true
## The wall climb speed (upward velocity).
@export var wall_climb_speed : float = 100

## Configuration settings for visualizing the Wall-based movement.
@export_group("Wall Movements Feature Visualization")
@export var is_visualize_wall_cling_enabled : bool = true
@export var wall_cling_feature_color : Color = Color(Constants.FeatureVisualizationColors.BLUE)
@export var is_visualize_wall_slide_enabled : bool = true
@export var wall_slide_feature_color : Color = Color(Constants.FeatureVisualizationColors.ORANGE)
@export var is_visualize_wall_climb_enabled : bool = true
@export var wall_climb_feature_color : Color = Color(Constants.FeatureVisualizationColors.WHITE)

var _is_cling_ready : bool = is_wall_cling_enabled
var _wall_cling_timer := Timer.new()
var _is_sliding : bool = false

## Fired when a character begins clinging to a wall.
signal char_wall_cling
## Fired when a character begins sliding down a wall.
signal char_wall_slide
## Fired when a character is climbing.
signal char_wall_climb

func handle_ready(body: CharacterBody2D):
	add_child(_wall_cling_timer)
	_wall_cling_timer.one_shot = true
	_wall_cling_timer.timeout.connect(_on_wall_cling_timer_timeout)

func handle_physics_process(delta: float, body: CharacterBody2D, previous_velocity: Vector2):
	if _should_wall_climb(body):
		_wall_climb(body)
	
	elif _should_wall_cling(body):
		_wall_cling(body, delta)
		
	elif _should_wall_slide(body):
		_wall_slide(body, delta)
		
	if _should_reset_cling_ready(body):
		_is_cling_ready = true
		
	if _should_reset_is_sliding(body):
		_is_sliding = false

## Wall Cling methods
func _should_wall_cling(body: CharacterBody2D) -> bool:
	if is_wall_cling_enabled and body.is_on_wall_only() and _is_cling_ready:
		var timer_is_running := not _wall_cling_timer.is_stopped()
		var still_has_time := _wall_cling_timer.get_time_left() > 0 if timer_is_running else true
		return _get_is_cling_input_pressed(body) and still_has_time
	return false

func _wall_cling(body: CharacterBody2D, delta: float) -> void:
	body.velocity.y = 0
	char_wall_cling.emit()

func _get_is_cling_input_pressed(body: CharacterBody2D) -> bool:
	if wall_cling_input_type == WALL_CLING_INPUT_TYPE.DIRECTIONAL:
		return _is_cling_with_directional_input(body)
	elif wall_cling_input_type == WALL_CLING_INPUT_TYPE.NON_DIRECTIONAL:
		return _is_cling_with_nondirectional_input()
	else:
		return false
	
func _is_cling_with_directional_input(body: CharacterBody2D) -> bool:
	var wall_direction_int = body.get_wall_normal().x * -1
	if Input.is_action_pressed("left") and wall_direction_int == -1:
		return true
	if Input.is_action_pressed("right") and wall_direction_int == 1:
		return true
	return false

func _is_cling_with_nondirectional_input() -> bool:
	return Input.is_action_pressed("wall_cling")

func _on_char_wall_cling():
	if wall_cling_duration_secs > 0 and _wall_cling_timer.is_stopped():
		_start_wall_cling_timer()

func _start_wall_cling_timer() -> void:
	_wall_cling_timer.start(wall_cling_duration_secs)
	if is_visualize_wall_cling_enabled:
		char_visualize_feature_enable.emit(wall_cling_feature_color)

func _on_wall_cling_timer_timeout() -> void:
	_is_cling_ready = false
	char_visualize_feature_disable.emit()
	
func _should_reset_cling_ready(body : CharacterBody2D) -> bool:
	return _is_cling_ready == false and body.is_on_floor()

## Wall Slide
func _should_wall_slide(body: CharacterBody2D) -> bool:
	return is_wall_slide_enabled \
		and body.is_on_wall_only()

func _wall_slide(body: CharacterBody2D, delta: float) -> void:
	body.velocity.y += (wall_slide_friction * delta)
	body.velocity.y = min(body.velocity.y, wall_slide_max_gravity)
	if not _is_sliding:
		_is_sliding = true
		char_wall_slide.emit() # NOTE: _is_sliding condition used to ensure that signal emits only once per slide
		if is_visualize_wall_slide_enabled:
			char_visualize_feature_enable.emit(wall_slide_feature_color)

func _should_reset_is_sliding(body : CharacterBody2D) -> bool:
	var should_reset = _is_sliding == true and body.is_on_floor()
	if should_reset:
		char_visualize_feature_disable.emit()
	return should_reset

## Wall Climb
func _should_wall_climb(body: CharacterBody2D) -> bool:
	return is_wall_climb_enabled \
		and Input.is_action_pressed("up") \
		and _is_cling_with_directional_input(body) \
		and body.is_on_wall_only()

func _wall_climb(body: CharacterBody2D) -> void:
	_is_sliding = false
	body.velocity.y = wall_climb_speed * -1
	char_wall_climb.emit()
	if is_visualize_wall_climb_enabled:
		char_visualize_feature_enable.emit(wall_climb_feature_color)
