extends Control

func _on_change_name_button_pressed():
	hide()

func _on_line_edit_text_changed(new_text):
	PlayerVariables.player_name = new_text
	PlayerVariables.save_name()
