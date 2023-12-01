extends AnimatedSprite2D


const do_not_interrupt = ["dash"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_char_visualize_feature_enable(color: Color) -> void:
	var is_enabled := 1
	self.material.set_shader_parameter("enabled", is_enabled)
	self.material.set_shader_parameter("color", color)

func _on_char_visualize_feature_disable():
	var is_enabled := 0
	self.material.set_shader_parameter("enabled", is_enabled)
	
func _on_char_idle_stand():
	self.play("idle_stand")

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
	_on_char_visualize_feature_disable()

func _on_jump_component_char_jump_wall_land():
	self.play("wall_land")

func _on_crouch_component_char_crouch_idle():
	self.play("crouch_idle")

func _on_crouch_component_char_crouch_walk():
	self.play("crouch_walk")

func _on_dash_component_char_dash_start():
	self.play("dash")

func _on_dash_component_char_dash_end():
	self.play("idle_stand")

func _on_walk_component_char_walk():
	self.play("walk")

func _on_test_char_char_face_direction(direction: float):
	var should_flip_horizontal = direction < 0
	self.flip_h = should_flip_horizontal

func _on_wall_movements_component_char_wall_cling():
	self.play("wall_land")

func _on_wall_movements_component_char_wall_slide():
	self.play("wall_slide")

func _on_wall_movements_component_char_wall_climb():
	self.play("wall_climb")
