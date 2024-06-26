extends Area2D

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	if not MultiplayerManager.multiplayer_mode_enabled:
		var in_game = await game_manager.end_game()
		if not in_game:
			animation_player.play("explosion")
	
