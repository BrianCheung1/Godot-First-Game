extends State
class_name RogueKnightStateCast

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[cast]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("Cast")
	animated_sprite.speed_scale = 2.5
	pulse()
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.speed_scale = 1
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass

func pulse():
	var pos = rogue_knight.player.global_position
	RogueKnightCast.create(rogue_knight, pos).go()
	await get_tree().create_timer(1).timeout
	RogueKnightCast.create(rogue_knight, pos).go()
	await get_tree().create_timer(1).timeout
	RogueKnightCast.create(rogue_knight, pos).go()
	await get_tree().create_timer(1).timeout
	RogueKnightCast.create(rogue_knight, pos).go()
	await get_tree().create_timer(1).timeout
	RogueKnightCast.create(rogue_knight, pos).go()
	await get_tree().create_timer(1).timeout
	
