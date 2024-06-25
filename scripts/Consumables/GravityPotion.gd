extends Item
class_name GravityPotion

func _init(player: Player, count):
	super(player, "Gravity Potion", count)
	
func activate():
	count -= 1
	print("Used " + name)
