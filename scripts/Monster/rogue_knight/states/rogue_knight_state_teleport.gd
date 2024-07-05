extends State
class_name RogueKnightStateTeleport

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[teleport]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("Teleport")
	animated_sprite.speed_scale = 2.5
	teleport(Vector2(-78, -103))
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.speed_scale = 1
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass

func teleport(loc: Vector2):
	RogueKnightTele.create(rogue_knight, rogue_knight.global_position).go()
	RogueKnightTele.create(rogue_knight, loc).go()
	await get_tree().create_timer(0.1).timeout
	rogue_knight.global_position = loc
