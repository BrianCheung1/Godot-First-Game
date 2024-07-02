extends Level

@onready var main_menu = $UI/Control/MainMenu

const WORLD_ATTACK_PLAYER_COOLDOWN = 3
const WORLD_ATTACK_COUNT = 5
const INTERVAL = 0.75

var rng = RandomNumberGenerator.new()
var world_attack_player_cooldown_left = WORLD_ATTACK_PLAYER_COOLDOWN
var world_attacking

var player: Player
var camera: Camera2D

func _ready():
	main_menu.hide()
	#AttackIndicator.create_from_positions(self, 999, Vector2(0, 0), Vector2(2000, 0), 25, AttackIndicator.Orientation.Horizontal).go()
	#AttackIndicator.create_from_positions(self, 999, Vector2(-1000, -1000), Vector2(0, 0), 25, AttackIndicator.Orientation.Vertical).go()
	#AttackIndicator.create_from_positions(self, 999, Vector2(-1000, -1000), Vector2(0, 0), 25, AttackIndicator.Orientation.Horizontal).go()
	var test = Util.traverse_up_until_level(self)
	if test != null:
		var level: Level = test
		player = level.get_children().filter(func(x): return x is Player)[0]
		camera = player.get_children().filter(func(x): return x is Camera2D)[0]

func _process(delta):
	world_attack_player_cooldown_left -= delta
	if world_attack_player_cooldown_left < 0 and not world_attacking:
		world_attacking = true
		for i in range(WORLD_ATTACK_COUNT):
			await get_tree().create_timer(INTERVAL).timeout
			generate_attack()
		world_attacking = false
		world_attack_player_cooldown_left = WORLD_ATTACK_PLAYER_COOLDOWN
		
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
		
		
