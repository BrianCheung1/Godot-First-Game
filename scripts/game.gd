extends Node2D


var level1
func _ready():
	if OS.has_feature("dedicated_server"):
		print("game started")
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func start_game():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	
func _on_ui_start_game():
	start_game()

func _on_ui_quit_to_menu():
	get_tree().quit()
