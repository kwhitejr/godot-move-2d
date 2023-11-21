extends BaseMenu


@onready var v_box_buttons = %VBoxButtons
@onready var selected_demo_label = %SelectedDemo

var demo_descriptions = {
	Game.DEMO.SANDBOX : "Sandbox",
	Game.DEMO.CELESTE_CLONE : "Celeste Clone"
}

signal start_game

# Handle buttons
func _on_start_game_button_pressed() -> void:
	start_game.emit()
	hide()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_button_select_demo_pressed():
	change_menu.emit(UI.MENU.DEMO_SELECT)

func focus_button() -> void:
	if v_box_buttons and visible:
		# refactor this to ensure button is always a Button
		var button : Button = v_box_buttons.get_child(0)
		button.grab_focus()

# Handle update to selected demo text
func _on_demo_select_select_demo(demo : Game.DEMO) -> void:
	var label_text_format := "Selected Demo: %s"
	var label_text : String = label_text_format % demo_descriptions[demo]
	
#	if (demo == Game.DEMO.SANDBOX):
#		label_text = label_text_format % "Sandbox"
#	if (demo == Game.DEMO.CELESTE_CLONE):
#		label_text = label_text_format % "Celeste Clone"
	
	selected_demo_label.text = label_text
