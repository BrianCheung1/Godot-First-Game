extends Control

signal return_to_game()
signal main_menu()

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var buttons_v_box = $MarginContainer/ButtonsVBox

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)

func focus_button():
	if buttons_v_box:
		var button:Button = buttons_v_box.get_child(1)
		if button is Button:
			button.grab_focus()

func _on_visibility_changed():
	if visible:
		focus_button()
		
func _on_return_to_game_button_pressed():
	return_to_game.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()
	if MultiplayerManager.multiplayer_mode_enabled:
		MultiplayerManager._del_player(multiplayer.get_unique_id())
		MultiplayerManager.multiplayer_mode_enabled = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
