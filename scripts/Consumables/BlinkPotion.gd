extends Item
class_name BlinkPotion

# Define the amount to blink (in pixels)
@export var blink_amount: int = 50
@export var sprite_texture: Texture

var sprite: Sprite2D = null

func _init(player: Player, count):
	super(player, "Blink Potion", count)
	# Ensure the sprite is added after initialization
	sprite = Sprite2D.new()
	if sprite_texture:
		sprite.texture = sprite_texture
	add_child(sprite)

func _ready():
	if sprite_texture:
		sprite.texture = sprite_texture

func activate():
	if _count == 0: 
		return
	_count -= 1
	var direction = -1 if _player.is_facing_right else 1
	_player.move_and_collide(Vector2(blink_amount * direction, 0))
	print("Used " + _name)
