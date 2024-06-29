extends Control

signal change_name()

func _on_change_name_button_pressed():
	change_name.emit()
	hide()

func _on_line_edit_text_changed(new_text):
	PlayerVariables.player_name = new_text
	PlayerVariables.save_file()

func _on_line_edit_2_text_changed(new_text):
	PlayerVariables.player_ip = new_text
	PlayerVariables.save_file()
	MultiplayerManager.SERVER_IP = str(PlayerVariables.player_ip)
