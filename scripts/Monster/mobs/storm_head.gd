extends Monster2D
class_name StormHead

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

	self.attack_padding = Vector2(base_size.x * 2,self.base_size.y/5)	
	self.attack_collision = Collision.create_new_shape_with_modified_extents(self.collision_node, self.attack_padding.x, self.attack_padding.y)

	self.attack_collision.disabled = true
	self.attack_direction = "AOE"
	var damageZone = self.get_node("DamageZone")
	damageZone.add_child(self.attack_collision)
	
