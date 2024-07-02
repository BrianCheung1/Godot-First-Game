extends Monster2D
class_name Boss

var drop_chance_percent = 50

var logger = Logger.new(["Boss"])

var possible_items = Item.new(null,null,null).possible_items()

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
	logger.print(["HP: ", self.hp])
	
