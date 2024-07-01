extends Item
class_name SuckCoinPotion

const ITEM_NAME = "SuckCoinPotion"
const sprite_source = "res://assets/sprites/4_item.png"

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
# Should make it so that it only sucks things on your screen
func activate():
	var candidate = _level.find_children("Coins", "", false)
	var coins_node = candidate[0] if candidate.size() > 0 else null
	if !coins_node:
		print("No coins to suck on this map")
		return
		
	var coins = coins_node.get_children()
	if coins.size() == 0:
		print("No more coins to suck on this map")
		return
		
	for coin: Coin in coins:
		if not (coin is Coin): continue
		coin.pick_up()
	_count -= 1
	print("Used " + _name)
