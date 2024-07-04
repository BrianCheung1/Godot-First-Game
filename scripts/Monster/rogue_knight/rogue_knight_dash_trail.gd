extends IndicatorAttackBase
class_name RogueKnightDashTrail

@export var rogue_knight: RogueKnight
var logger = Logger.new("[rogue knight dash]")
var is_static_position = true
var rng = RandomNumberGenerator.new()

func _ready():
	animated_sprites = [$AnimatedSprite2D]
	hitbox = $DamageZone/CollisionShape2D
	super._ready()

# Override abstract class to do positioning/rotations specific to this attack
func do_positioning():
	if is_static_position: return
	for sprite in animated_sprites:
		sprite.flip_h = rogue_knight.is_facing_right
	#print("global", global_position)
	#print("knight global", rogue_knight.global_position)
	global_position.x = rogue_knight.global_position.x - 35 if rogue_knight.is_facing_right else rogue_knight.global_position.x + 35
	global_position.y =  rogue_knight.global_position.y + 8
	#print("global after", global_position)

func _process(delta):
	#print(get_viewport().get_mouse_position())
	pass
	
static func create(parent: RogueKnight) -> RogueKnightDashTrail:
	var res = load("res://scenes/monsters/rogue_knight/rogue_knight_dash_trail.tscn")
	var node: RogueKnightDashTrail = res.instantiate()
	
	# Try to find Level node
	var find_level = Util.traverse_up_until_level(parent)
	if find_level == null: return
	var level: Level = find_level
	
	# Spawn it on the level
	node.rogue_knight = parent
	node.is_static_position = false
	level.add_child(node)
	
	return node
