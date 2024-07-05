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
	RogueKnightCast.create(rogue_knight, rogue_knight.player).go()
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass
