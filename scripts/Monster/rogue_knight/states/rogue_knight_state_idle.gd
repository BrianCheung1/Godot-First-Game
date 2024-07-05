extends State
class_name RogueKnightStateIdle

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

# DEBUG SEQUENCE
var index = 0
var duration: float
var states = ["SimpleAttack", "Run", "Teleport", "FullAttack", "Thunder", "Dash", "Cast"]
func _ready():
	logger.append_prefix("[idle]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("Idle")
	await animated_sprite.animation_finished
	duration = 0.3
	
func exit():
	rogue_knight.velocity.x = 0
	animated_sprite.stop()
	
func update(delta):
	duration -= delta
	if duration < 0:
		on_transition.emit(self, states[index])
		index = (index + 1) % states.size()

func update_physics(delta):
	pass
