extends CanvasLayer
@onready var player_name = $MarginContainer2/VBoxContainer/PlayerName

func change_winner(new_winner):
	player_name.text = str(new_winner)


