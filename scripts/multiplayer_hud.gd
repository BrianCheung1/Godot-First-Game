extends CanvasLayer

signal host_game()
signal join_as_player_2()
signal single_player()

func _on_single_player_pressed():
	single_player.emit()

func _on_host_game_pressed():
	host_game.emit()

func _on_join_as_player_2_pressed():
	join_as_player_2.emit()


