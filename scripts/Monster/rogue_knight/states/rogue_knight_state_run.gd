extends State
class_name RogueKnightStateRun

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var life_time: float
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[run]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	life_time = 2
	animated_sprite.play("Run")
	
	var run_velocity = rogue_knight.speed if rng.randf() < 0.5 else -rogue_knight.speed
	rogue_knight.velocity.x = run_velocity
	
func exit():
	rogue_knight.velocity.x = 0
	animated_sprite.stop()
	
func update(delta):
	life_time -= delta
	if life_time < 0:
		on_transition.emit(self, "Idle")

func update_physics(delta):
	pass
