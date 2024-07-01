extends Area2D

var logger
@onready var player = get_tree().get_first_node_in_group("player")
@onready var attack_speed_timer = $AttackSpeedTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_2d = $DamageZone/CollisionShape2D

func _ready():
	logger = Logger.new("[Lightning Scene]")
	global_position.x = player.global_position.x
	global_position.y = player.global_position.y - 45
	animated_sprite.frame = 0
	attack_speed_timer.start()
	AttackIndicator.create_from_collisionshape2d(self, attack_speed_timer.wait_time, collision_shape_2d, "fade").go()
	
func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_attack_speed_timer_timeout():
	animated_sprite.play("lightning")
	collision_shape_2d.disabled = false

func _on_damage_zone_body_entered(body):
	if body is Player:
		body.hit(25)
