extends Control


@onready var v_box_buttons = %VBoxButtons

signal start_game
signal change_menu(menu : UI.MENU)

func _ready() -> void:
	focus_button()

func _on_start_game_button_pressed() -> void:
	start_game.emit()
	hide()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()
		
func _on_button_select_demo_pressed():
	change_menu.emit(UI.MENU.DEMO_SELECT)

func focus_button() -> void:
	if v_box_buttons and self.visible == true:
		# refactor this to ensure button is always a Button
		var button : Button = v_box_buttons.get_child(0)
		button.grab_focus()
