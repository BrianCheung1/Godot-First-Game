extends State
class_name RogueKnightStateDash

@export var dash_velocity: float
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[dash]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("Dash")
	dash()
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	rogue_knight.velocity.x = 0
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass

func dash():
	rogue_knight.velocity.x = dash_velocity if rng.randf() < 0.5 else -dash_velocity
	await get_tree().create_timer(0.25).timeout
	RogueKnightDashTrail.create(rogue_knight).go()
