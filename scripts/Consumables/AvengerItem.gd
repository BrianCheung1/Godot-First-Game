extends Item
class_name AvengerItem

const ITEM_NAME = "AvengerItem"
const sprite_source = "res://assets/sprites/star.png"

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
func activate():
	self.logger.print(["Item Activated : ", ITEM_NAME])
	
	var avenger = has_avenger(_player)
	
	if _player && avenger != null:
		avenger.activate()
	else:
		avenger = Avenger.new(_player, 50)
		_player.add_child(avenger)
	
func has_avenger(player: Node):
	for child in player.get_children():
		if child is Avenger:
			return child
	return null
