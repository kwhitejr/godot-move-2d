class_name Game
extends Node2D


@onready var ui = %UI

enum DEMO {
	SANDBOX,
	CELESTE_CLONE
}

@onready var demos = {
	DEMO.SANDBOX : preload("res://src/demos/sandbox/sandbox-demo.tscn"),
	DEMO.CELESTE_CLONE : preload("res://src/demos/celeste-clone/celeste-clone.tscn")
}

var selected_demo : DEMO = DEMO.SANDBOX

func start_game() -> void:
	# Instantiate selected demo
#	var demo_instance = demos[demo].instantiate()
	var demo_instance = demos[selected_demo].instantiate()
	
	# Add demo to Game scene
	add_child(demo_instance)
	
	# Make demo first child.
	move_child(demo_instance, 0)

	# Connect player to ui
	# TODO: move this to character scope
	var player = get_tree().get_root().find_child("TestChar",true,false)
	if not player.char_collect_pickup.is_connected(ui._on_collected):
		player.char_collect_pickup.connect(ui._on_collected)

func _on_ui_start_game() -> void:
	start_game()

func _on_ui_select_demo(demo : DEMO) -> void:
	selected_demo = demo
