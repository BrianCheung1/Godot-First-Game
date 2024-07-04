extends IndicatorAttackBase
class_name RogueKnightTele

@export var rogue_knight: RogueKnight
var logger = Logger.new("[rogue knight simple slash]")
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
	#print("global", global_position)
	#print("knight global", rogue_knight.global_position)
	global_position = target_loc
	#print("global after", global_position)

func _process(delta):
	#print(get_viewport().get_mouse_position())
	pass
	
static func create(parent: RogueKnight, target_loc: Vector2) -> RogueKnightTele:
	var res = load("res://scenes/monsters/rogue_knight/rogue_knight_tele.tscn")
	var node: RogueKnightTele = res.instantiate()
	
	# Try to find Level node
	var find_level = Util.traverse_up_until_level(parent)
	if find_level == null: return
	var level: Level = find_level
	
	# Spawn it on the level
	node.rogue_knight = parent
	node.is_static_position = false
	node.target_loc = target_loc
	level.add_child(node)
	
	return node
