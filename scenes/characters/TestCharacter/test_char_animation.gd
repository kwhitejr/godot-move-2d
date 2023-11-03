extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("animation ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_char_idle_stand(is_on_floor : bool):
	if is_on_floor:
		self.play("idle_stand")

func _on_char_idle_crouch():
	self.play("idle_crouch")

func _on_char_jump_ascend():
	self.play("jump_ascend")

func _on_char_jump_apex():
	self.play("jump_apex")

func _on_char_jump_air():
	self.play("jump_air")

func _on_char_jump_descend():
	self.play("jump_descend")

func _on_char_jump_landed():
	self.play("jump_land")

func _on_char_move_left(is_on_floor : bool):
	self.flip_h = true
	if is_on_floor:
		self.play("run")

func _on_char_move_right(is_on_floor : bool):
	self.flip_h = false
	if is_on_floor:
		self.play("run")
