extends Item
class_name HealthPotion

var logger = Logger.new("[HealthPotion]")

const ADDITIONAL_HEALTH = 10

func _init(player: Player, count):
	super(player, "Invincibility Buff", count)
	_player.add_child(self)
	
func activate():
	#_player.add_child(self)
	print("Item Activated")
	
	if(_player.hp == _player.MAX_HP):
		logger.print("Not used: MAX HP")
		return
		
	_player.hp = max(_player.hp + ADDITIONAL_HEALTH, _player.MAX_HP) 
	_count -= 1
	
