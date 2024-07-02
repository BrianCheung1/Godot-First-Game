extends Item
class_name ExplosionItem

const ITEM_NAME = "ExplosionItem"
const sprite_source = "res://assets/sprites/explosion-1.png"


func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
func activate():
	self.logger.print(["Item Activated : ", ITEM_NAME])
	
	var explosion = has_explosion(_player)
	
	if _player && explosion != null:
		explosion.activate()
	else:
		explosion = Explosion.new(_player)
		_player.add_child(explosion)
	
func has_explosion(player: Node):
	for child in player.get_children():
		if child is Explosion:
			return child
	return null
