extends Item
class_name BlinkPotion

# Define the amount to blink (in pixels)
@export var blink_amount: int = 50
const ITEM_NAME = "BlinkPotion"
const sprite_source = "res://assets/sprites/2_item.png"
const desc = "Blink player 50 pixels in the direction they are facing"
const cost = 10

func _init(player: Player, count):
	super(player, ITEM_NAME, count, desc, cost, load(sprite_source))

func activate():
	if _count == 0: 
		return
	_count -= 1
	var direction = -1 if _player.is_facing_right else 1
	_player.move_and_collide(Vector2(blink_amount * direction, 0))
	print("Used " + _name)
