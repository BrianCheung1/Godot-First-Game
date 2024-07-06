extends Skill

class_name Balls

const ANIMATED_BLUE_BALL = preload("res://scenes/effect_scenes/animated_blue_ball.tscn")
var sub = true
func _init(skill_owner, damage):
	var base_attack_size = Vector2(1, 1)
	var distance = Vector2(15, 0)
	var logger_name = "[Blue Ball]"
	var attack_warning = .5

	super(skill_owner, damage, base_attack_size, ANIMATED_BLUE_BALL, distance, logger_name, attack_warning)

func _process(delta):
	default_process(delta)
	if(self.attack_duration <= 0 and not activated):
		var direction = Util.direction(Util.find_target(body))
		var player = Util.find_target(body)
		#var position_holder = self.previous_player_position
		var position_holder = player.position
		
		for i in range (20):
			if(direction == "Right"):
				var position = position_holder - Vector2(randi_range(-100, 100),randi_range(-75, 75))
				self.previous_player_position = position
			
			if(direction == "Left"):
				var position = position_holder + Vector2(randi_range(-100, 100),randi_range(-75, 75))
				self.previous_player_position = position
			
			spawn_attack()
			
func spawn_attack():
	var skill_duration = 2
	var speed_mulitplier = 2
	var attack_stats = AttackStats.new(damage, DISTANCE, self.previous_player_position, skill_duration, speed_mulitplier, Util.direction(body), ATTACK_SIZE)
	var attack_sprite = Sprite.resize_packed_scene(ANIMATED_BLUE_BALL, ATTACK_SIZE, self.previous_player_position)
	if(Util.direction(body) == "Left"):
		attack_sprite.flip_h = true
	var attack = CreateAttack.new(attack_sprite, attack_stats, body)
	get_tree().root.add_child(attack)

