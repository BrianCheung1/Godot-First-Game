extends Monster2D
class_name RogueKnight

const THUNDER_ATTACK_COUNT = 7
const THUNDER_INTERVAL = 0.5
@onready var animation = $AnimatedSprite2D

var logger = Logger.new("[rogue knight]")
var index
var sprite_frames: SpriteFrames
var animation_names

func _ready():
	index = 0
	sprite_frames = animation.sprite_frames
	animation_names = sprite_frames.get_animation_names()
	logger.print(animation_names)
	
	animation.animation_changed.connect(on_changed)
	animation.animation_finished.connect(on_finished)
	animation.play(animation_names[index])

func _process(delta):
	pass

func on_changed():
	var cur = animation_names[index]
	if cur == "MultiCast":
		summon_thunder()
	
func on_finished():
	index = (index + 1) % animation_names.size()
	animation.play(animation_names[index])

func summon_thunder():
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	for i in range(THUNDER_ATTACK_COUNT):
		await get_tree().create_timer(THUNDER_INTERVAL).timeout
		RogueKnightThunder.create(self, player).go()
