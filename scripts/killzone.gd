extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("You Died")
	Engine.time_scale = 1
	body.is_alive = false
	body.animated_sprite.play("death")
	body.hurt.play()
	body.set_collision_layer_value(2, false)
	body.set_collision_layer_value(3, true)
	timer.start()
	

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
