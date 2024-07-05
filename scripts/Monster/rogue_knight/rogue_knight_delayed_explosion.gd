extends IndicatorAttackBase
class_name RogueKnightDelayedExplosion

@export var rogue_knight: RogueKnight
var logger = Logger.new("[rogue knight delayed explosion]")
var is_static_position = true
var rng = RandomNumberGenerator.new()
var target_loc: Vector2

func _ready():
	animated_sprites = [$AnimatedSprite2D]
	hitbox = $DamageZone/CollisionShape2D
	super._ready()

# Override abstract class to do positioning/rotations specific to this attack
func do_positioning():
	if is_static_position: return
	global_position = target_loc

func _process(delta):
	#print(get_viewport().get_mouse_position())
	pass
	
static func create(parent: RogueKnight, target_loc: Vector2) -> RogueKnightDelayedExplosion:
	var res = load("res://scenes/monsters/rogue_knight/rogue_knight_delayed_explosion.tscn")
	var node: RogueKnightDelayedExplosion = res.instantiate()
	
	# Try to find Level node
	var find_level = Util.traverse_up_until_level(parent)
	if find_level == null: return
	var level: Level = find_level
	
	# Spawn it on the level
	node.rogue_knight = parent
	node.target_loc = target_loc
	node.is_static_position = false
	level.add_child(node)
	
	return node
