extends Monster2D
class_name RogueKnight

@onready var animation = $AnimatedSprite2D

var logger = Logger.new("[rogue knight]")
var index
var player: Player
var sprite_frames: SpriteFrames
var animation_names: PackedStringArray

func _ready():
	index = 6
	sprite_frames = animation.sprite_frames
	animation_names = sprite_frames.get_animation_names()
	logger.print(animation_names)
	player = get_tree().get_nodes_in_group("player")[0]
	super._ready()

func _process(delta):
	pass

# ["AttackFull", "AttackSimple", "Cast", "Dash", "Idle", "MultiCast", "Run", "Teleport"]
