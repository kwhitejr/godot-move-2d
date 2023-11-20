extends Control


@onready var v_box_buttons = %VBoxButtons

signal select_demo(demo_name : String)
signal change_menu(menu : UI.MENU)

func _ready() -> void:
	focus_button()

func _on_demo_button_pressed() -> void:
	# load selected demo into Game state
	# navigate back to main menu
	select_demo.emit()
	hide()
	
func _on_back_button_pressed() -> void:
	change_menu.emit(UI.MENU.MAIN)

func _on_visibility_changed() -> void:
	if visible:
		focus_button()
		
func focus_button() -> void:
	if v_box_buttons and self.visible == true:
		# refactor this to ensure button is always a Button
		var button : Button = v_box_buttons.get_child(0)
		button.grab_focus()
