extends Skill

class_name Explosion

@onready var attackTexture:Texture = preload("res://assets/sprites/explosion-1.png")
const ANIMATED_EXPLOSION = preload("res://scenes/effect_scenes/animated_explosion.tscn")

func _init(skill_owner, damage):
	var base_attack_size = Vector2(6, 4)
	var distance = Vector2(1, 0)
	var logger_name = "[Explosion]"
	var attack_warning = 1

	super(skill_owner, damage, base_attack_size, ANIMATED_EXPLOSION, distance, logger_name, attack_warning)

func spawn_attack():
	var body_pos = body.global_position + Vector2(0, ATTACK_SIZE.y/4)
	var skill_duration = .25
	var speed_mulitplier = 0
	var attack_stats = AttackStats.new(damage, DISTANCE, body_pos, skill_duration, speed_mulitplier, Util.direction(body), ATTACK_SIZE, false)
	var attack_sprite = Sprite.resize_packed_scene(ANIMATED_EXPLOSION, ATTACK_SIZE, body_pos)
	if(Util.direction(body) == "Left"):
		attack_sprite.flip_h = true
	var attack = CreateAttack.new(attack_sprite, attack_stats, body)
	get_tree().root.add_child(attack)

