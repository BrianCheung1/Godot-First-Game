extends Area2D
@onready var collision_shape_2d = $CollisionShape2D

var multiplayer_scene = preload("res://scenes/multiplayer_player.tscn")
func _on_body_entered(body):
	if MultiplayerManager.multiplayer_mode_enabled:
		%VictoryScreen.change_winner(body.player_id)
		%VictoryScreen.show()
		collision_shape_2d.disabled = true
		#if MultiplayerManager.multiplayer_mode_enabled and multiplayer.get_unique_id() == body.player_id:
			#print("Player %s WINS!" % multiplayer.get_unique_id())
			#for players in get_tree().get_current_scene().get_node("Players").get_children():
				#MultiplayerManager._del_player(players.player_id)
			#await get_tree().create_timer(1).timeout
			#MultiplayerManager.join_as_player_2()
			#await get_tree().create_timer(1).timeout
		await get_tree().create_timer(5).timeout
		if not OS.has_feature("dedicated_server"):
			MultiplayerManager.multiplayer_mode_enabled = false
			get_tree().change_scene_to_file("res://scenes/game.tscn")
