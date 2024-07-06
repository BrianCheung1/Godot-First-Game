extends State
class_name RogueKnightStateFullAttack

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[full attack]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("AttackFull")
	attack_full()
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass

func attack_full():
	var locs
	# First Slash
	RogueKnightSimpleSlash.create(rogue_knight).go()
	await get_tree().create_timer(0.5).timeout
	
	# Second Slash
	if rogue_knight.is_facing_right:
		locs = [
			Vector2(rogue_knight.global_position.x + 30, rogue_knight.global_position.y + 20),
			Vector2(rogue_knight.global_position.x + 40, rogue_knight.global_position.y - -5),
			Vector2(rogue_knight.global_position.x + 50, rogue_knight.global_position.y - 10),
			Vector2(rogue_knight.global_position.x + 40, rogue_knight.global_position.y - 25),
			Vector2(rogue_knight.global_position.x + 30, rogue_knight.global_position.y - 40),
		]
	else:
		locs = [
			Vector2(rogue_knight.global_position.x - 35, rogue_knight.global_position.y + 20),
			Vector2(rogue_knight.global_position.x - 45, rogue_knight.global_position.y - -5),
			Vector2(rogue_knight.global_position.x - 55, rogue_knight.global_position.y - 10),
			Vector2(rogue_knight.global_position.x - 45, rogue_knight.global_position.y - 25),
			Vector2(rogue_knight.global_position.x - 35, rogue_knight.global_position.y - 40),
		]
	RogueKnightDelayedExplosion.create(rogue_knight, locs[0]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(rogue_knight, locs[1]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(rogue_knight, locs[2]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(rogue_knight, locs[3]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(rogue_knight, locs[4]).go()
	
	# Third slash
	await get_tree().create_timer(0.5).timeout
	var char_size = Util.try_get_rectangle_size(rogue_knight.damage_collision)
	var pillar_locs = [
		Vector2(rogue_knight.global_position.x + 70, rogue_knight.global_position.y + 18) if rogue_knight.is_facing_right else Vector2(rogue_knight.global_position.x - 75, rogue_knight.global_position.y + 18),
		Vector2(rogue_knight.global_position.x + 90, rogue_knight.global_position.y + 18) if rogue_knight.is_facing_right else Vector2(rogue_knight.global_position.x - 95, rogue_knight.global_position.y + 18),
		Vector2(rogue_knight.global_position.x + 110, rogue_knight.global_position.y + 18) if rogue_knight.is_facing_right else Vector2(rogue_knight.global_position.x - 115, rogue_knight.global_position.y + 18),
		Vector2(rogue_knight.global_position.x + 130, rogue_knight.global_position.y + 18) if rogue_knight.is_facing_right else Vector2(rogue_knight.global_position.x - 135, rogue_knight.global_position.y + 18),
		Vector2(rogue_knight.global_position.x + 150, rogue_knight.global_position.y + 18) if rogue_knight.is_facing_right else Vector2(rogue_knight.global_position.x - 155, rogue_knight.global_position.y + 18)
	]
	RogueKnightMeleePillar.create(rogue_knight, pillar_locs[0]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightMeleePillar.create(rogue_knight, pillar_locs[1]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightMeleePillar.create(rogue_knight, pillar_locs[2]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightMeleePillar.create(rogue_knight, pillar_locs[3]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightMeleePillar.create(rogue_knight, pillar_locs[4]).go()
