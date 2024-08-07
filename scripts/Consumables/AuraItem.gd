extends Item
class_name AuraItem

const buff_time = 10
const ITEM_NAME = "AuraItem"
var duration = 0
const sprite_source = "res://assets/sprites/5_item.png"
var desc = "Gives player an aura for an extra 10 seconds"
var cost = 20


func _init(player: Player, count):
	super(player, ITEM_NAME, count, desc, cost, load(sprite_source))
	
func activate():
	if(_player):
		_player.add_child(self)
	self.logger.print(["Item Activated : ", ITEM_NAME])
	_count -= 1
	duration = duration + buff_time
	_player.aura.enable(true)
	
func _process(delta):
	if(duration <= 0):
		_player.aura.enable(false)
		_player.remove_child(self)
		return
		
	duration -= delta
