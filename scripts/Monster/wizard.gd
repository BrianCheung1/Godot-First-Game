extends Monster2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var attack_speed_timer = $AttackSpeedTimer

var is_attacking = false
var fireball = preload("res://scenes/monster_attacks/fireball.tscn")

func _physics_process(delta):
	if is_attacking:
		animated_sprite.play("attack")
	else:
		animated_sprite.play("idle")
	velocity.y += gravity * delta
	var direction = global_position.direction_to(player.global_position)
	
	if direction.x > 0.1:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	move_and_slide()

func _on_area_2d_body_entered(body):
	pass
	#print("Entered")
	#is_attacking = true
	#var fireball_attack = fireball.instantiate()
	#add_child(fireball_attack)
	#attack_speed_timer.start()

#func _on_area_2d_body_exited(body):
	#print("Exited")
	#print(body.name)
	#is_attacking = false
	#attack_speed_timer.stop()
#
#func _on_timer_timeout():
	#var fireball_attack = fireball.instantiate()
	#add_child(fireball_attack)
	#attack_speed_timer.wait_time = randf_range(3, 5)
	#attack_speed_timer.start()
	#is_attacking = false
	
func _on_animated_sprite_2d_animation_finished():
	print(animated_sprite.animation)
	if animated_sprite.animation == "attack":
		var fireball_attack = fireball.instantiate()
		add_child(fireball_attack)
