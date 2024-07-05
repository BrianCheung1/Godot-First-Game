extends IndicatorAttackBase
class_name RogueKnightThunder

@export var player: Player

var logger = Logger.new("[rogue knight thunder]")
var is_static_position = true
var rng = RandomNumberGenerator.new()

func _ready():
	animated_sprites = [$AnimatedSprite2D, $AnimatedSprite2D2, $AnimatedSprite2D3, $AnimatedSprite2D4, $AnimatedSprite2D5, $AnimatedSprite2D6, $AnimatedSprite2D7]
	hitbox = $DamageZone/CollisionShape2D
	super._ready()

# Override abstract class to do positioning/rotations specific to this attack
func do_positioning():
	if is_static_position: return
	
	var camera: Camera2D = player.camera
	var target_pos: Vector2 = Vector2(player.global_position)
	var view_rect: Vector2 = get_viewport().get_visible_rect().size / camera.zoom
	var hitbox_rect: Vector2 = Util.try_get_rectangle_size(hitbox)
	#target_pos.x += rng.randf_range(-100, 100)
	global_position.x = target_pos.x + rng.randf_range(-view_rect.x, view_rect.x)
	global_position.y = target_pos.y - hitbox_rect.y/2 + rng.randi_range(0, 25)
	look_at(target_pos)

func _process(delta):
	pass
	
static func create(parent: RogueKnight, player: Player) -> RogueKnightThunder:
	var res = load("res://scenes/monsters/rogue_knight/rogue_knight_thunder.tscn")
	var node: RogueKnightThunder = res.instantiate()
	
	# Try to find Level node
	var find_level = Util.traverse_up_until_level(parent)
	if find_level == null: return
	var level: Level = find_level
	
	# Spawn it on the level
	node.player = player
	node.is_static_position = false
	level.add_child(node)
	
	return node
