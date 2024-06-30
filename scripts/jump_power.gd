extends Area2D
@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	body.jump_velocity = -475
	animation_player.play("pickup")
