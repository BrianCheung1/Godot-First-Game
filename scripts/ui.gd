extends CanvasLayer

@onready var main_menu = $"Control/MainMenu"
@onready var game_menu = $Control/GameMenu

signal start_game()
signal game_menu_opened()
signal game_menu_closed()
signal quit_to_menu()

func _on_main_menu_start_game():
	start_game.emit()

func _input(event):
	if !main_menu.visible and event.is_action_pressed("ui_cancel"):
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
