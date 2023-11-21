class_name BaseMenu
extends Control

signal change_menu(menu : UI.MENU)

func _ready() -> void:
	if visible:
		focus_button()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()

func focus_button() -> void:
	push_warning("NOT IMPLEMENTED: BaseMenu.focus_button()")
