extends Area2D

class_name ItemLoot

var logger = Logger.new("[Item Loot]")

var item_name

var determineItem = {
	"Blink Potion" : BlinkPotion,
	"Gravity Potion" : GravityPotion,
	"Kill All Potion": KillAllPotion,
	"Suck Coin Potion" : SuckCoinPotion,
	"Aura Item": AuraItem,
	"Invincibility Buff": InvincibilityBuff,
}

const target_size = Vector2(10,10)

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	var sprite = self.get_child(0)
	if(sprite is Sprite2D):
		var texture = load(Item.itemSpriteSource[self.item_name])
		var scale_factor = target_size/texture.get_size()
		sprite.scale = scale_factor
		sprite.texture = texture
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(_body):
	if(_body is Player):
		add_item(_body)

func add_item(_body:Player):
	logger.print(["Adding",self.item_name])
	_body.inventory.add_item(determine_item(_body))
	queue_free() #delete item from the scene 

func determine_item(_body:Player):
	return determineItem[self.item_name].new(_body,1)
