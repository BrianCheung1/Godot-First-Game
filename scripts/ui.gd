extends CanvasLayer

@onready var main_menu = $"Control/MainMenu"
@onready var game_menu = $Control/GameMenu
@onready var level_menu = $Control/LevelMenu
@onready var highscore_menu = $Control/HighscoreMenu

signal start_game()
signal game_menu_opened()
signal game_menu_closed()
signal quit_to_menu()

func _on_main_menu_start_game():
	level_menu.show()
	main_menu.hide()

func _input(event):
	if !main_menu.visible and event.is_action_pressed("ui_cancel"):
		if game_menu:
			game_menu.visible = !game_menu.visible
		if game_menu.visible:
			game_menu_opened.emit()
		else:
			game_menu_closed.emit()

func _on_game_menu_main_menu():
	game_menu.hide()
	quit_to_menu.emit()
	main_menu.show()
		
func _on_game_menu_return_to_game():
	game_menu.hide()
	game_menu_closed.emit()

func _on_main_menu_highscores():
	highscore_menu.show()

func _on_level_menu_levels_to_menu():
	main_menu.show()
	level_menu.hide()
