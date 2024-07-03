extends Area2D

class_name Explosion

@onready var attackTexture:Texture = preload("res://assets/sprites/explosion-1.png")

var activated = false
var logger = Logger.new("[Explosion]")
var body
var damage:int
var current_position:Vector2
var attack_collision
var ATTACK_WARNING:float
var attack_duration:float
var ATTACK_SIZE:Vector2


func spawn_attack():
	#logger.print("Creating new Explosion")
	var body_pos = body.global_position
	var attack_stats = AttackStats.new(damage, Vector2(0,0), body_pos, .25, 5, Util.direction(body), self.ATTACK_SIZE)
	var attack_sprite = Sprite.create_sprite(attackTexture, self.ATTACK_SIZE, body_pos)
	var attack = CreateAttack.new(attack_sprite,attack_stats, body)
	get_tree().root.add_child(attack)

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.attack_duration > 0) && !activated:
		self.attack_duration-=delta
		#AttackIndicator.create_from_collisionshape2d(body,ATTACK_WARNING,attack_collision, AttackIndicator.Type.Fade).go()
		return
		
	if(self.attack_duration <= 0) && !activated:
		#logger.print("Explosion Activated")
		spawn_attack()
		activated = true
	

func activate():
	#logger.print(["Explosion Activated"])
	self.attack_duration = self.ATTACK_WARNING
	activated = false

func _init(skill_owner, damage):
	self.damage = damage
	self.body = skill_owner
	self.current_position =	Util.get_character_body_size(skill_owner)
	self.ATTACK_SIZE = Vector2(100,15)
	self.attack_collision = Collision.create_rectangle(self.ATTACK_SIZE,skill_owner.global_position)
	self.ATTACK_WARNING = 1.5
	self.attack_duration = self.ATTACK_WARNING
	self.add_child(self.attack_collision)
		
	collision_layer =  3 | 1 | 4
	collision_mask = 3 | 1 | 4
	if(body is Player):
		self.ATTACK_WARNING = 0
