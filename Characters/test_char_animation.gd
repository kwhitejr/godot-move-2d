extends AnimatedSprite2D


const do_not_interrupt = ["dash"]

const PINK := Color("#e61baab5")
const BLUE := Color("#68e8ff")
const GREEN := Color("#a9ff99")
const YELLOW := Color("#ebff99")
const ORANGE := Color("#ffb999")
const PURPLE := Color("#e299fe")
const WHITE := Color("#ffffff")
const TRANSPARENT := Color(0, 0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_char_idle_stand(body : CharacterBody2D):
#	if do_not_interrupt.has(self.get_animation()):
#		return

	if is_zero_approx(body.velocity.x) and body.is_on_floor():
		self.play("idle_stand")

func _on_char_idle_crouch():
	self.play("idle_crouch")

func _on_jump_component_char_jump_ascend():
	self.play("jump_ascend")

func _on_jump_component_char_jump_apex():
	self.play("jump_apex")

func _on_jump_component_char_jump_air():
	self.play("jump_air")

func _on_jump_component_char_jump_descend():
	self.play("jump_descend")

func _on_jump_component_char_jump_landed():
	self.play("jump_land")
	self.material.set_shader_parameter("enabled", 0)

func _on_crouch_component_char_idle_crouch():
	self.play("idle_crouch")

func _on_dash_component_char_dash_start():
	self.play("dash")

func _on_dash_component_char_dash_end():
	self.play("idle_stand")

func _on_walk_component_char_walk(body: CharacterBody2D):
	if do_not_interrupt.has(self.get_animation()):
		return
	if body.is_on_floor():
		self.play("walk")

func _on_test_char_char_face_direction(direction: float):
	var should_flip_horizontal = direction == -1
	self.flip_h = should_flip_horizontal 


func _on_jump_component_char_visualize_feature(feature: String) -> void:
	var is_enabled : int = 0 if feature == "disabled" else 1
	var color : Color = _get_visualization_color(feature)
	self.material.set_shader_parameter("enabled", is_enabled)
	self.material.set_shader_parameter("color", color)

func _get_visualization_color(feature: String) -> Color:
	match feature:
		"coyote_time":
			return BLUE
		"jump_buffer":
			return PINK
		"disabled":
			return TRANSPARENT
	return TRANSPARENT
	
