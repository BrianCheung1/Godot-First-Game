extends State
class_name RogueKnightStateBossTest

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
const boss_test_attack_res = preload("res://scenes/monsters/rogue_knight/rogue_knight_boss_test.tscn")

var rogue_knight: RogueKnight
var player: Player
var original_camera_zoom
var rng = RandomNumberGenerator.new()

func _ready():
	logger.append_prefix("[boss test]")
	
func enter():
	logger.print("Entered")
	rogue_knight = character as RogueKnight
	player = rogue_knight.player
	original_camera_zoom = player.camera.zoom
	
	animated_sprite.play("Test")
	camera_tween_to(Vector2(1.5,1.5))
	await get_tree().create_timer(1).timeout
	
	# Used to calculate the width of the pillars instead of hardcoding cause why not
	var boss_attack_node = boss_test_attack_res.instantiate()
	boss_attack_node.global_position = Vector2(-9999,-9999)
	rogue_knight.add_child(boss_attack_node)
	var rect_size = Util.try_get_rectangle_size(boss_attack_node.hitbox)
	boss_attack_node.queue_free()
	
	# Spawn pillars
	await summon_pillars(rect_size)
	await get_tree().create_timer(1).timeout
	await summon_pillars(rect_size)
	await get_tree().create_timer(1).timeout
	await summon_pillars(rect_size)
		
	# End phase
	await get_tree().create_timer(2).timeout
	on_transition.emit(self, "Idle")
	
func exit():
	animated_sprite.stop()
	camera_tween_to(original_camera_zoom)
	
func update(delta):
	pass

func update_physics(delta):
	pass
	
func camera_tween_to(to: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(player.camera, "zoom", to, 0.75)

func summon_pillars(rect_size: Vector2):
	var num_start = -15
	var num_end = 15
	var skip_index = rng.randi_range(num_start, num_end)
	var attack = null
	for i in range(num_start, num_end):
		if i == skip_index: continue
		attack = RogueKnightTestAttack.create(rogue_knight, player.global_position + Vector2((rect_size.x + 3)*i, 0))
		attack.go()
	return attack.animated_sprites[0].animation_finished # Make function awaitable
