extends State
class_name RogueKnightStateThunder

@export var thunder_attack_count: int
@export var thunder_interval: float

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
var rogue_knight: RogueKnight
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[thunder]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character
	animated_sprite.play("MultiCast")
	summon_thunder()
	await animated_sprite.animation_finished
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.stop()
	
func update(delta):
	pass

func update_physics(delta):
	pass

func summon_thunder():
	await get_tree().create_timer(1).timeout
	for i in range(thunder_attack_count):
		await get_tree().create_timer(thunder_interval).timeout
		RogueKnightThunder.create(rogue_knight, rogue_knight.player).go()
