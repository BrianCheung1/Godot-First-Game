extends Item
class_name GravityPotion 

const ITEM_NAME = "GravityPotion"
const sprite_source = "res://assets/sprites/2_item.png"

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
func activate():
	_count -= 1
	self.logger.print(["Item Activated : ", ITEM_NAME])
