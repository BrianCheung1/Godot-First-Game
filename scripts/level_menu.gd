extends Control

signal levels_to_menu()
func _on_level_1_button_pressed():
	print("Level 1")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	PlayerVariables.player_deaths = 0
	PlayerVariables.player_resets = 0

func _on_level_2_button_pressed():
	print("Level 2")
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	PlayerVariables.player_deaths = 0
	PlayerVariables.player_resets = 0

func _on_main_menu_button_pressed():
	levels_to_menu.emit()

func _on_level_3_button_pressed():
	print("Level 3")
	get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	PlayerVariables.player_deaths = 0
	PlayerVariables.player_resets = 0
