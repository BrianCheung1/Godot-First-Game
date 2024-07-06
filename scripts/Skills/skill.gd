extends Area2D

class_name Skill

var activated = false
var logger
var body
var damage:int
var current_position:Vector2
var attack_collision_indicator:CollisionShape2D
var ATTACK_WARNING:float
var attack_duration:float
var ATTACK_SIZE:Vector2
var DISTANCE:Vector2 
var attack_animation
var previous_player_position:Vector2

func _init(skill_owner, damage, base_attack_size:Vector2, attack_animation, distance:Vector2, logger_name:String, attack_warning:float):
	self.body = skill_owner
	self.damage = damage
	self.attack_animation = attack_animation
	self.current_position = Util.get_character_body_size(skill_owner)
	self.ATTACK_SIZE = base_attack_size * Vector2(min(current_position.x, current_position.y), min(current_position.x, current_position.y))
	self.DISTANCE = distance
	self.logger = Logger.new(logger_name)
	
	var a = self.body.global_position + Vector2(0, ATTACK_SIZE.y/4) + Vector2(0,self.current_position.y)
	self.attack_collision_indicator = Collision.create_rectangle((ATTACK_SIZE) , a)
	self.ATTACK_WARNING = attack_warning
	
	collision_layer =  3 | 1 | 4
	collision_mask = 3 | 1 | 4
	if body is Player:
		self.ATTACK_WARNING = 0.0
	else:
		self.add_child(self.attack_collision_indicator)
	
	self.attack_duration = self.ATTACK_WARNING

func _ready():
	pass

func default_process(delta):
	if self.attack_duration > 0 and not activated:
		self.attack_duration -= delta
		AttackIndicator.create_from_collisionshape2d(body, ATTACK_WARNING, attack_collision_indicator, AttackIndicator.Type.Fade).go()
		return
	
	if self.attack_duration <= 0 and not activated:
		spawn_attack()
		activated = true

func _process(delta):
	default_process(delta)

func activate():
	logger.print(["Attack Activated", str(self.ATTACK_WARNING)])
	self.attack_duration = self.ATTACK_WARNING
	activated = false
	var body = Util.find_target(body)
	if(body != null):
		previous_player_position = body.global_position

func spawn_attack():
	pass  # Placeholder for child class implementation

