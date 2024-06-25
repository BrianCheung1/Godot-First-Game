extends Area2D
@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	body.JUMP_VELOCITY = -458
	animation_player.play("pickup")
