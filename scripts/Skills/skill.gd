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
var attack_texture:Texture

func _init(skill_owner, damage, base_attack_size:Vector2, texture:Texture, distance:Vector2, logger_name:String, attack_warning:float):
	self.body = skill_owner
	self.damage = damage
	self.attack_texture = texture
	self.current_position = Util.get_character_body_size(skill_owner)
	self.ATTACK_SIZE = base_attack_size * Vector2(min(current_position.x, current_position.y), min(current_position.x, current_position.y))
	self.DISTANCE = distance
	self.logger = Logger.new(logger_name)
	self.attack_collision_indicator = Collision.create_rectangle(ATTACK_SIZE + DISTANCE, skill_owner.global_position)
	self.ATTACK_WARNING = attack_warning
	
	collision_layer =  3 | 1 | 4
	collision_mask = 3 | 1 | 4
	if body is Player:
		self.ATTACK_WARNING = 0.0
	else:
		self.add_child(self.attack_collision_indicator)
		self.ATTACK_WARNING = 1.5
	
	self.attack_duration = self.ATTACK_WARNING

func _ready():
	pass

func _process(delta):
	if self.attack_duration > 0 and not activated:
		self.attack_duration -= delta
		AttackIndicator.create_from_collisionshape2d(body, ATTACK_WARNING, attack_collision_indicator, AttackIndicator.Type.Fade).go()
		return
		
	if self.attack_duration <= 0 and not activated:
		spawn_attack()
		activated = true

func activate():
	self.attack_duration = self.ATTACK_WARNING
	activated = false

func spawn_attack():
	pass  # Placeholder for child class implementation

