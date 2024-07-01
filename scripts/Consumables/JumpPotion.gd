extends Item
class_name JumpPotion

const buff_time = 10
const ITEM_NAME = "JumpPotion"
const sprite_source = "res://assets/sprites/8_item.png"
var duration = 0
const JUMP_MODIFIER = 100

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
func activate():		
	self.logger.print(["Item Activated : ", ITEM_NAME])
	if(_player):
		_player.add_child(self)
	
	duration = duration + buff_time
	_count -= 1
	
	if _player.jump_velocity == _player.JUMP_VELOCITY_BASE:
		_player.jump_velocity -= JUMP_MODIFIER
	
func _process(delta):
	if(duration <= 0):
		_player.jump_velocity = _player.JUMP_VELOCITY_BASE
		self.logger.print(["Removed Buff :", ITEM_NAME])
		_player.remove_child(self)
		return
		
	duration -= delta
