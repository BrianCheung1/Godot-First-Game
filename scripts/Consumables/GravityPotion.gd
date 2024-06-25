extends Item
class_name GravityPotion

func _init(player: Player, count):
	super(player, "Gravity Potion", count)
	
func activate():
	_count -= 1
	print("Used " + _name)
