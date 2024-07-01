extends Item
class_name InvincibilityBuff

const buff_duration = 5
var duration = 0

func _init(player: Player, count):
	super(player, "Invincibility Buff", count)
	_player.add_child(self)
	
func activate():
	#_player.add_child(self)
	print("Item Activated")
	_count -= 1
	_player.invincibility_time_left += buff_duration
	
