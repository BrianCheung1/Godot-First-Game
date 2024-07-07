extends Skill

class_name Avenger

#@onready var attackTexture:Texture = preload("res://assets/sprites/star.png")
const ANIMATED_STAR = preload("res://scenes/effect_scenes/animated_star.tscn")

func _init(skill_owner, damage):
	var base_attack_size = Vector2(1, 1)
	var distance = Vector2(25, 0)
	var logger_name = "[Avenger]"
	var attack_warning = 1.5

	super(skill_owner, damage, base_attack_size, ANIMATED_STAR, distance, logger_name, attack_warning)

func spawn_attack():
	var body_pos = body.global_position + Vector2(0, ATTACK_SIZE.y/4) + Vector2(0,self.current_position.y/2)
	
	if body.ray_cast_down.is_colliding():
		var floor_position = body.ray_cast_down.get_collision_point()
		if(body_pos < floor_position):
			body_pos.y = floor_position.y
			
	var attack_stats = AttackStats.new(damage, DISTANCE, body_pos, 2, 5, Util.direction(body), ATTACK_SIZE, false)
	var scene_instance = Sprite.resize_packed_scene(ANIMATED_STAR,ATTACK_SIZE, body_pos)
	var attack = CreateAttack.new(scene_instance, attack_stats, body)
	get_tree().root.add_child(attack)
