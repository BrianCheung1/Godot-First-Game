extends Area2D

@onready var timer = $Timer
@onready var timer_time = timer.wait_time

func _on_body_entered(body):
	print("You Died")
	body.is_alive = false
	body.animated_sprite.play("death")
	body.hurt.play()
	body.set_collision_layer_value(2, false)
	body.set_collision_layer_value(3, true)
	timer.start()
	
func _on_timer_timeout():
	get_tree().reload_current_scene()
	
func _on_tree_exiting():
	print("OG Time " + str(timer_time))
	print("Time Now " + str(timer.time_left))
	if timer.time_left < timer_time and timer.time_left > 0:
		get_tree().reload_current_scene()
