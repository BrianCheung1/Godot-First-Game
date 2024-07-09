extends Item
class_name KillAllPotion

const ITEM_NAME = "KillAllPotion"
const sprite_source = "res://assets/sprites/3_item.png"
const Slime = preload("res://scripts/Monster/mobs/slime.gd")

func _init(player: Player, count):
	super(player, ITEM_NAME, count)
	
# This won't work for new monster types in the future... Only for slimes right now
func activate():
	var candidate = _level.find_children("Slimes", "", false)
	var slimes_node = candidate[0] if candidate.size() > 0 else null
	if !slimes_node:
		self.logger.print(["Failed : ", "No slimes to kill on this map"])
		return
	var slimes = slimes_node.get_children()
	
	if not slimes.any(func(x): return x is Slime):
		self.logger.print(["Failed : ", "No slimes to kill on this map"])
		return
		
	for slime in slimes:
		if not (slime is Slime): continue
		slime = slime as Slime
		slime.hit(5)
	_count -= 1
	self.logger.print(["Item Activated : ", ITEM_NAME])
