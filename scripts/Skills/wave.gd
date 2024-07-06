extends Skill

class_name Wave

@onready var attackTexture:Texture = preload("res://assets/sprites/9_item.png")
@onready var puddleSprite:Texture = preload("res://assets/sprites/water.png")
@onready var my_timer = Timer.new()
var puddle_duration = 5
var attack
var total_duration = 5

func _init(skill_owner, damage):
	self.add_child(my_timer)
	var base_attack_size = Vector2(2, 2)
	var distance = Vector2(10, 0)
	var logger_name = "[Wave]"
	var attack_warning = 0

	super(skill_owner, damage, base_attack_size, attackTexture, distance, logger_name, attack_warning)

func spawn_attack():
	var body_pos = body.global_position
	if(body is Monster2D or body is SlimeBoss):
		body_pos = get_tree().get_first_node_in_group("player").global_position
	
	var attack_stats = AttackStats.new(damage, DISTANCE, body_pos, total_duration, 5, Util.direction(body), ATTACK_SIZE)
	var attack_sprite = Sprite.create_sprite(attackTexture, ATTACK_SIZE, body_pos)
	if(Util.direction(body) == "Left"):
		attack_sprite.flip_h = true
		
	attack = CreateAttack.new(attack_sprite, attack_stats, body)
	get_tree().root.add_child(attack)
	puddle_duration = total_duration
	
	
func _process(delta):
	if self.attack_duration > 0 and not activated:
		self.attack_duration -= delta
		AttackIndicator.create_from_collisionshape2d(body, ATTACK_WARNING, attack_collision_indicator, AttackIndicator.Type.Fade).go()
		return
		
	if self.attack_duration <= 0 and not activated:
		spawn_attack()
		activated = true
	
	if(activated && puddle_duration >= 0):
		if(attack == null):
			return
		
		puddle_duration -= delta
		
		spawn_puddle()
	
	
func spawn_puddle():
	var puddle_stats = AttackStats.new(1, Vector2(0,0), attack.collision_shape.global_position,puddle_duration , total_duration, Util.direction(body), Vector2(2,2))
	var puddle_sprite = Sprite.create_sprite(puddleSprite, Vector2(2,2), attack.global_position)
	var puddle = CreateAttack.new(puddle_sprite, puddle_stats, body)
	get_tree().root.add_child(puddle)
