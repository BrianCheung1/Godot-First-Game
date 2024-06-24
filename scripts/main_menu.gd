extends Control


signal start_game()
@onready var buttons_v_box = $MarginContainer/VBoxContainer/ButtonsVBox
@onready var leaderboard_ui = $LeaderboardUI
@onready var user_interface = $UserInterface
@onready var player_name = $MarginContainer/VBoxContainer/PlayerName

func _ready():
	focus_button()
	
func _on_start_game_button_pressed():
	start_game.emit()
	hide()
	
func _on_end_game_button_pressed():
	get_tree().quit()
	
func focus_button():
	if buttons_v_box:
		var button:Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()

func _on_visibility_changed():
	if visible:
		focus_button()

func _on_high_score_button_pressed():
	leaderboard_ui.show()
	buttons_v_box.hide()
	player_name.hide()

func _on_close_button_pressed():
	leaderboard_ui.hide()
	buttons_v_box.show()
	player_name.show()

func _on_change_name_button_pressed():
	user_interface.show()

func _physics_process(_delta):
	player_name.text = PlayerVariables.player_name
