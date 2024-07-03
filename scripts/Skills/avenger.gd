extends Area2D

class_name Avenger

@onready var attackTexture:Texture = preload("res://assets/sprites/star.png")

var logger = Logger.new("[Avenger]")
var body
var ATTACK_WARNING = 1
var attack_duration = ATTACK_WARNING
var activated = false
var damage
var attack_stats:AttackStats
var ATTACK_SIZE 
var current_position:Vector2
var attackIndicator 
var attack_collision

func spawn_attack():
	#logger.print("Creating new Avenger")
	var body_pos = body.global_position
	self.attack_stats = AttackStats.new(damage, Vector2(25,0), body_pos, 2, 5, Util.direction(body), ATTACK_SIZE)
	var attack_sprite = Sprite.create_sprite(attackTexture, ATTACK_SIZE, body_pos)
	var attack = CreateAttack.new(attack_sprite, self.attack_stats, body)

	get_tree().root.add_child(attack)

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#logger.print(delta)
	if(attack_duration > 0) && !activated:
		attack_duration-=delta
		AttackIndicator.create_from_collisionshape2d(body,ATTACK_WARNING,attack_collision, AttackIndicator.Type.Fade).go()
		return
		
	if(attack_duration <= 0) && !activated:
		spawn_attack()
		activated = true
	

func activate():
	#logger.print(["Avenger Activated"])
	attack_duration = ATTACK_WARNING
	activated = false

func _init(skill_owner, damage):
	self.current_position = Util.get_character_body_size(skill_owner)
	self.body = skill_owner
	self.damage = damage
	self.ATTACK_SIZE = Vector2(25,25)/2
	self.attack_collision = Collision.create_rectangle(ATTACK_SIZE,skill_owner.global_position)
	self.add_child(self.attack_collision)
	
	collision_layer =  3 | 1 | 4
	collision_mask = 3 | 1 | 4
	if(body is Player):
		ATTACK_WARNING = 0
