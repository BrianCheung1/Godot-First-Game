extends Area2D

@onready var timer = $Timer
@onready var timer_time = timer.wait_time


func _on_body_entered(body):
	if not MultiplayerManager.multiplayer_mode_enabled:
		body.is_alive = false
		body.animated_sprite.play("death")
		body.hurt.play()
		body.set_collision_layer_value(2, false)
		body.set_collision_layer_value(3, true)
		timer.start()
	else:
		_multiplayer_dead(body)
		
func _multiplayer_dead(body):
	if multiplayer.is_server():
		body.is_dead()
		
func _on_timer_timeout():
	if not MultiplayerManager.multiplayer_mode_enabled:
		get_tree().reload_current_scene()
		PlayerVariables.player_deaths +=1
		
	
func _on_tree_exiting():
	if timer.time_left < timer_time and timer.time_left > 0:
		get_tree().reload_current_scene()
		PlayerVariables.player_deaths +=1
