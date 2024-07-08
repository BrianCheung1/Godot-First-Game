extends Area2D
class_name Coin

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	pick_up()
	
func pick_up():
	game_manager.add_coins()
	animation_player.play("pickup")
