extends Monster2D
class_name BallAndChainBot

var drop_chance_percent = 20

var possible_items = ["BlinkPotion", "AuraItem", "InvincibilityBuff", "HealthPotion", "JumpPotion"]

# Overrides the original die function
func die():
	var item = generate_random_item()
	if(item):
		super.generate_item_node(item)
		
	super.die()

func generate_random_item():
	if rng.randf_range(0, 100) >= drop_chance_percent:
		return null
	
	return possible_items[rng.randi_range(0, possible_items.size() - 1)]

func _ready():
	super._ready() 
	self.need_offset = false
	
