extends Monster2D
class_name SmallMonster

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
	self.need_offset = true
	self.attack_padding = Vector2(base_size.x * .8,0)
	self.attack_collision = Collision.create_new_shape_with_modified_extents(self.collision_node, self.attack_padding.x, 0)

	self.attack_collision.disabled = true
	self.attack_direction = "Front"
	var damageZone = self.get_node("DamageZone")
	damageZone.add_child(self.attack_collision)

