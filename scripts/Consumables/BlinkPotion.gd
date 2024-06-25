extends Item
class_name BlinkPotion

# Define the amount to blink (in pixels)
@export var blink_amount: int = 50

func _init(player: Player, count):
	super(player, "Blink Potion", count)
	
func activate():
	if count == 0: 
		return
	count -= 1
	var direction = -1 if player.direction < 0 else 1
	player.move_and_collide(Vector2(blink_amount * direction, 0))
	print("Used " + name)
