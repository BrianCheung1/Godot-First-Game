extends Level

@onready var main_menu = $UI/Control/MainMenu

const WORLD_ATTACK_PLAYER_COOLDOWN = 2
const WORLD_ATTACK_COUNT = 7
const INTERVAL = 0.5

var rng = RandomNumberGenerator.new()
var world_attack_player_cooldown_left = WORLD_ATTACK_PLAYER_COOLDOWN
var world_attacking

var player: Player
var camera: Camera2D

func _ready():
	main_menu.hide()
	player = self.get_children().filter(func(x): return x is Player)[0]
	camera = player.camera
	for thunder: RogueKnightThunder in get_children().filter(func(x): return x is RogueKnightThunder):
		thunder.go()

func _process(delta):
	pass
	#world_attack_player_cooldown_left -= delta
	#if world_attack_player_cooldown_left < 0 and not world_attacking:
		#world_attacking = true
		#for i in range(WORLD_ATTACK_COUNT):
			#await get_tree().create_timer(INTERVAL).timeout
			#RogueKnightThunder.create(self, player).go()
		#world_attacking = false
		#world_attack_player_cooldown_left = WORLD_ATTACK_PLAYER_COOLDOWN
		
# Example of black mage chain generating attack from above the camera...
func generate_attack():
	var pos = camera.get_screen_center_position()
	print("pos", pos)
	var rect_size = get_viewport().get_visible_rect().size / camera.zoom
	print("rectsize", rect_size)
	print("mouse", get_viewport().get_mouse_position())
	var beam_height = (rect_size.y / 2) + 75
	var bottom_y_offset = rng.randi_range(0, 10)
	var top_x_offset = rng.randi_range(-rect_size.x / 2, rect_size.x / 2)
	#var bottom_x_offset = rng.randi_range(-rect_size.x / 3, rect_size.x / 3)
	var bottom_x_offset = 0
	AttackIndicator.create_from_positions(self, 
		2, 
		Vector2(pos.x + top_x_offset, pos.y - beam_height), 
		Vector2(pos.x + bottom_x_offset, pos.y + bottom_y_offset), 
		25, 
		AttackIndicator.Orientation.Vertical, 
		AttackIndicator.Type.Fade
	).go()
		
		
