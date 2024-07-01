extends Item
class_name HealthPotion

const ITEM_NAME = "HealthPotion"
const ADDITIONAL_HEALTH = 15
const sprite_source = "res://assets/sprites/7_item.png"

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
func activate():
	self.logger.print(["Item Activated : ", ITEM_NAME])
	
	if(_player.hp == _player.MAX_HP):
		self.logger.print("Failed : MAX HP")
		return
		
	_player.hp = min(_player.hp + ADDITIONAL_HEALTH, _player.MAX_HP) 
	_count -= 1
	
