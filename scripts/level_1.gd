extends Node2D


@onready var main_menu = $UI/Control/MainMenu
@onready var leaderboard_ui = $GameManager/CanvasLayer/LeaderboardUI

func _ready():
	main_menu.hide()



func _on_close_button_pressed():
	leaderboard_ui.hide()
	get_tree().paused = false
