extends Monster2D
class_name Slime

var drop_change = 25

# Overrides the original die function
func die():
	var item = generate_random_item()
	if(item):
		super.generate_item_node(item)
	super.die()

func generate_random_item():
	if(drop_change <= rng.randi_range(0,100)):
		return null
	
	var possible_items = Item.itemSpriteSource.keys()
	return possible_items[rng.randi_range(0, possible_items.size()-1)]

func _ready():
	super._ready() 
	

