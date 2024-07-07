extends Skill

class_name Balls

const ANIMATED_BLUE_BALL = preload("res://scenes/effect_scenes/animated_blue_ball.tscn")
var sub = true
var ball_positions = []
var attack_warning = 1

func _init(skill_owner, damage):
	var base_attack_size = Vector2(1, 1)
	var distance = Vector2(15, 0)
	var logger_name = "[Blue Ball]"

	super(skill_owner, damage, base_attack_size, ANIMATED_BLUE_BALL, distance, logger_name, attack_warning)

func _process(delta):
	super._process(delta)
	if(self.attack_duration <= 0 and not activated):
		for i in ball_positions:
			self.previous_player_position = i
			spawn_attack()
		ball_positions = []

func activate():
	super.activate()
	var direction = Util.direction(Util.find_target(body))
	var player = Util.find_target(body)
	var position_holder = player.position
		
	for i in range (20):
		if(direction == "Right"):
			var position = position_holder - Vector2(randi_range(-100, 100),randi_range(-75, 75))
			ball_positions.append(position)
			add_child(BlinkingIndicator.new(self.ATTACK_SIZE,position, attack_warning, body))
			
		if(direction == "Left"):
			var position = position_holder + Vector2(randi_range(-100, 100),randi_range(-75, 75))
			ball_positions.append(position)
			add_child(BlinkingIndicator.new(self.ATTACK_SIZE,position, attack_warning, body))

func spawn_attack():
	var skill_duration = 2
	var speed_mulitplier = 2
	var attack_stats = AttackStats.new(damage, DISTANCE, self.previous_player_position, skill_duration, speed_mulitplier, Util.direction(body), ATTACK_SIZE, false)
	var attack_sprite = Sprite.resize_packed_scene(ANIMATED_BLUE_BALL, ATTACK_SIZE, self.previous_player_position)
	if(Util.direction(body) == "Left"):
		attack_sprite.flip_h = true
	var attack = CreateAttack.new(attack_sprite, attack_stats, body)
	get_tree().root.add_child(attack)

