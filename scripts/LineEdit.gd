extends LineEdit

func _on_change_name_button_pressed():
	hide()

func _on_text_changed(new_text):
	PlayerVariables.player_name = new_text
