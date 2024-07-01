extends Item
class_name InvincibilityBuff

const buff_duration = 5
const ITEM_NAME = "InvincibilityBuff"
var duration = 0
const sprite_source = "res://assets/sprites/6_item.png"

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	if(player):
		_player.add_child(self)
	
func activate():
	self.logger.print(["Item Activated : ", ITEM_NAME])
	_count -= 1
	_player.invincibility_time_left += buff_duration
	
