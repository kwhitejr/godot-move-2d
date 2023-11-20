class_name Game
extends Node2D


@export var DemoScene : PackedScene
@export var ui : UI

func start_game() -> void:
	# Instantiate selected demo
	var demo = DemoScene.instantiate()
	
	# Add demo to Game scene
	add_child(demo)
	
	# Make demo first child.
	move_child(demo, 0)

	# Connect player to ui
	# TODO: move this to character scope
	var player = get_tree().get_root().find_child("TestChar",true,false)
	if not player.char_collect_pickup.is_connected(ui._on_collected):
		player.char_collect_pickup.connect(ui._on_collected)

func _on_ui_start_game():
	start_game()
