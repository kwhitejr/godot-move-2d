extends BaseMenu


@onready var v_box_buttons = %VBoxButtons

signal select_demo(demo : Game.DEMO)

# Handle return to main menu
func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		_go_to_main_menu()

func _on_back_button_pressed() -> void:
	_go_to_main_menu()

func _go_to_main_menu() -> void:
	change_menu.emit(UI.MENU.MAIN)

# Handle focus for buttons
func focus_button() -> void:
	if v_box_buttons and visible:
		# refactor this to ensure button is always a Button
		var button : Button = v_box_buttons.get_child(0)
		button.grab_focus()

# Handle demo selection
func _on_select_demo(demo : Game.DEMO) -> void:
	select_demo.emit(demo)
	_go_to_main_menu()

func _on_button_celeste_clone_demo_pressed():
	_on_select_demo(Game.DEMO.CELESTE_CLONE)

func _on_button_sandbox_demo_pressed():
	_on_select_demo(Game.DEMO.SANDBOX)
