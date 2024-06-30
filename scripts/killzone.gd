extends Area2D

@onready var timer = $Timer
@onready var timer_time = timer.wait_time


func _on_body_entered(body):
	if not body is Player:
		print("Kill zone but body is not a player")
		return
	if MultiplayerManager.multiplayer_mode_enabled:
		_multiplayer_dead(body)
		return
	var player: Player = body
	player.die()
	
func _multiplayer_dead(body):
	if multiplayer.is_server():
		body.is_dead()
		
#func _on_timer_timeout():
	#if MultiplayerManager.multiplayer_mode_enabled:
		#return
	#get_tree().reload_current_scene()
	#PlayerVariables.player_deaths +=1
		
#func _on_tree_exiting():
	#if timer.time_left < timer_time and timer.time_left > 0:
		#get_tree().reload_current_scene()
		#PlayerVariables.player_deaths +=1
