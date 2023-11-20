class_name UI
extends CanvasLayer


enum MENU {
	MAIN,
	DEMO_SELECT
}

@onready var menus = {
	MENU.MAIN : %MainMenu,
	MENU.DEMO_SELECT : %DemoSelect
}
@onready var score_label = %Score

signal start_game

var score = 0:
	set(new_score):
		score = new_score
		_update_score_label()

func _update_score_label() -> void:
	score_label.text = str(score)

func _on_collected(pickup : Pickup) -> void:
	if pickup:
		score += 100

func _on_main_menu_start_game() -> void:
	start_game.emit()

func show_menu(menu : MENU) -> void:
	for menu_type in menus.keys():
		var current_menu = menus[menu_type]
		if (menu == menu_type):
			current_menu.visible = true
		else:
			current_menu.visible = false

func _on_menu_change_menu(menu : MENU) -> void:
	show_menu(menu)
