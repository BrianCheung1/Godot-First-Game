extends Control


func _on_level_1_button_pressed():
	print("Level 1")
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_level_2_button_pressed():
	print("Level 2")
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
