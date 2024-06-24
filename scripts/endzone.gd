extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	var in_game = game_manager.end_game()
	if not in_game:
		animation_player.play("explosion")
	await Leaderboards.post_guest_score("butter-knights-butter-knights-2wUo", PlayerVariables.player_time, PlayerVariables.player_name)
