extends Item
class_name AuraItem

const buff_time = 10
var duration = 0

func _init(player: Player, count):
	super(player, "Aura Item", count)
	_player.add_child(self)
func activate():
	#_player.add_child(self)
	print("Item Activated")
	_count -= 1
	duration = duration + buff_time
	_player.aura.enable(true)
	
func _process(delta):
	if(duration <= 0):
		_player.aura.enable(false)
		return
		
	duration -= delta
