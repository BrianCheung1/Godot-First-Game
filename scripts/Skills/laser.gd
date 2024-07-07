extends Skill

class_name Laser

const ANIMATED_LASER = preload("res://scenes/effect_scenes/animated_laser.tscn")
var attack_warning = 1.5
	
func _init(skill_owner, damage):
	var base_attack_size = Vector2(7, 1)
	var distance = Vector2(0, 0)
	var logger_name = "[Laser]"

	super(skill_owner, damage, base_attack_size, ANIMATED_LASER, distance, logger_name, attack_warning)

func activate():
	super.activate()
	var offset = 0
	if(body.animated_sprite_2d.flip_h):
		offset = -(self.current_position.x/2) - self.ATTACK_SIZE.x
	else:
		offset = +(self.current_position.x/2) 
	var body_pos = body.global_position + Vector2(offset, 0) 
	body_pos.y = min(0, body_pos.y)
	print(body_pos)
	add_child(BlinkingIndicator.new(self.ATTACK_SIZE,body_pos, attack_warning, body))

func _process(delta):
	if self.attack_duration > 0 and not activated:
		self.attack_duration -= delta
		return
	default_process(delta)

func spawn_attack():
	var direction = Util.direction(Util.find_target(body))
	var offset = 0
	if(body.animated_sprite_2d.flip_h):
		offset = -self.current_position.x * 3
	else:
		offset = +self.current_position.x * 3
	
	
	var body_pos = body.global_position + Vector2(offset, ATTACK_SIZE.y/4) + Vector2(0,self.current_position.y/2)
	body_pos.y = min(0, body_pos.y)
	if body.ray_cast_down.is_colliding():
		var floor_position = body.ray_cast_down.get_collision_point()
		if(body_pos < floor_position):
			body_pos.y = floor_position.y
			
	var attack_stats = AttackStats.new(damage, DISTANCE, body_pos, 2, 5, Util.direction(body), ATTACK_SIZE, true)
	var scene_instance = Sprite.resize_packed_scene(ANIMATED_LASER,ATTACK_SIZE, body_pos)
	var attack = CreateAttack.new(scene_instance, attack_stats, body)
	get_tree().root.add_child(attack)
