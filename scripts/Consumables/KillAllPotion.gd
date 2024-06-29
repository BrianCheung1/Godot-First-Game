extends Item
class_name KillAllPotion

func _init(player: Player, count):
	super(player, "Kill All Potion", count)
	
# This won't work for new monster types in the future... Only for slimes right now
func activate():
	var candidate = _level.find_children("Slimes", "", false)
	var slimes_node = candidate[0] if candidate.size() > 0 else null
	if !slimes_node:
		print("No slimes to kill on this map")
		return
	var slimes = slimes_node.get_children()
	if not slimes.any(func(x): return x is Slime):
		print("No more slimes to kill on this map")
		return
		
	for slime in slimes:
		if not (slime is Slime): continue
		slime = slime as Slime
		slime.hit(25)
	_count -= 1
	print("Used " + _name)
