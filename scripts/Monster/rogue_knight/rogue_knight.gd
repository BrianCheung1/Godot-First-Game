extends Monster2D
class_name RogueKnight

const THUNDER_ATTACK_COUNT = 7
const THUNDER_INTERVAL = 0.5
@onready var animation = $AnimatedSprite2D
@export var dash_velocity: int

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
	
	animation.animation_changed.connect(on_changed)
	animation.animation_finished.connect(on_finished)
	animation.play.call_deferred(animation_names[index])
	super._ready()

func _process(delta):
	pass

# ["AttackFull", "AttackSimple", "Cast", "Dash", "Idle", "MultiCast", "Run", "Teleport"]
func on_changed():
	var cur = animation_names[index]
	if cur == "MultiCast":
		summon_thunder()
	elif cur == "Dash":
		velocity.x = dash_velocity if rng.randf() < 0.5 else -dash_velocity
		dash()
	elif cur == "AttackSimple":
		simple_slash()
	elif cur == "AttackFull":
		attack_full()
	elif cur == "Cast":
		cast()
	elif cur == "Teleport":
		teleport(Vector2(-78, -103))
	elif cur == "Idle":
		velocity = Vector2.ZERO
	elif cur == "Run":
		var run_velocity = speed if rng.randf() < 0.5 else -speed
		velocity.x = run_velocity
		
	
func on_finished():
	var cur = animation_names[index]
	if cur == "Run" || cur == "Dash":
		velocity = Vector2.ZERO
		
	index = rng.randi_range(0, animation_names.size()-1)
	animation.play(animation_names[index])

func teleport(loc: Vector2):
	RogueKnightTele.create(self, self.global_position).go()
	RogueKnightTele.create(self, loc).go()
	await get_tree().create_timer(0.1).timeout
	self.global_position = loc
	
func cast():
	RogueKnightCast.create(self, player).go()
	 
func simple_slash():
	RogueKnightSimpleSlash.create(self).go()
	
func attack_full():
	print("attack full")
	is_facing_right = false
	var locs
	
	# First Slash
	RogueKnightSimpleSlash.create(self).go()
	await get_tree().create_timer(1).timeout
	
	# Second Slash
	if is_facing_right:
		locs = [
			Vector2(global_position.x + 30, global_position.y + 20),
			Vector2(global_position.x + 40, global_position.y - -5),
			Vector2(global_position.x + 50, global_position.y - 10),
			Vector2(global_position.x + 40, global_position.y - 25),
			Vector2(global_position.x + 30, global_position.y - 40),
		]
	else:
		locs = [
			Vector2(global_position.x - 35, global_position.y + 20),
			Vector2(global_position.x - 45, global_position.y - -5),
			Vector2(global_position.x - 55, global_position.y - 10),
			Vector2(global_position.x - 45, global_position.y - 25),
			Vector2(global_position.x - 35, global_position.y - 40),
		]
	RogueKnightDelayedExplosion.create(self, locs[0]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(self, locs[1]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(self, locs[2]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(self, locs[3]).go()
	await get_tree().create_timer(0.025).timeout
	RogueKnightDelayedExplosion.create(self, locs[4]).go()
	
	# Third slash
	await get_tree().create_timer(0.5).timeout
	var char_size = Util.try_get_rectangle_size(damage_collision)
	var pillar_loc = Vector2(global_position.x + 70, global_position.y + 18) if is_facing_right else Vector2(global_position.x - 75, global_position.y + 18) 
	RogueKnightMeleePillar.create(self, pillar_loc).go()
	
func dash():
	await get_tree().create_timer(0.025).timeout
	RogueKnightDashTrail.create(self).go()
	
func summon_thunder():
	await get_tree().create_timer(1).timeout
	for i in range(THUNDER_ATTACK_COUNT):
		await get_tree().create_timer(THUNDER_INTERVAL).timeout
		RogueKnightThunder.create(self, player).go()
