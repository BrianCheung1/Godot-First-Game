extends Monster2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var attack_speed_timer = $AttackSpeedTimer

var is_attacking = false
var is_attacking_cooldown = randf_range(0, 2)
var fireball = preload("res://scenes/monster_attacks/fireball.tscn")

func _physics_process(delta):
	is_attacking_cooldown -= delta
	if is_attacking and is_attacking_cooldown <= 0:
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
	print("Entered")
	is_attacking = true
	#attack_speed_timer.start()

func _on_area_2d_body_exited(body):
	print(body.name)
	is_attacking = false
	#attack_speed_timer.stop()
#
	
func _on_animated_sprite_2d_animation_finished():
	print(animated_sprite.animation)
	if animated_sprite.animation == "attack":
		var fireball_attack = fireball.instantiate()
		add_child(fireball_attack)
		is_attacking_cooldown = randf_range(2, 5)
