#extends Area2D
#
#class_name Avenger
#
#@onready var attackTexture:Texture = preload("res://assets/sprites/star.png")
#
#var logger = Logger.new("[Avenger]")
#
#var activated = false
#
#var body
#var damage:int
#var current_position:Vector2
#var attack_collision_indicatior:CollisionShape2D
#var ATTACK_WARNING:float
#var attack_duration:float
#var ATTACK_SIZE:Vector2
#var DISTANCE:Vector2 
#
#func spawn_attack():
	##logger.print("Creating new Avenger")
	#var body_pos = body.global_position
	#var attack_stats = AttackStats.new(damage, self.DISTANCE, body_pos, 2, 5, Util.direction(body), ATTACK_SIZE)
	#var attack_sprite = Sprite.create_sprite(attackTexture, ATTACK_SIZE, body_pos)
	#var attack = CreateAttack.new(attack_sprite, attack_stats, body)
#
	#get_tree().root.add_child(attack)
#
#func _ready():
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	##logger.print(delta)
	#if(self.attack_duration > 0) && !activated:
		#attack_duration-=delta
		#AttackIndicator.create_from_collisionshape2d(body,ATTACK_WARNING,attack_collision_indicatior, AttackIndicator.Type.Fade).go()
		#return
		#
	#if(self.attack_duration <= 0) && !activated:
		#spawn_attack()
		#activated = true
	#
#
#func activate():
	##logger.print(["Avenger Activated"])
	#attack_duration = ATTACK_WARNING
	#activated = false
#
#func _init(skill_owner, damage):
	#var base_attack_size = Vector2(1,1)
	#self.body = skill_owner
	#self.damage = damage
	#self.current_position = Util.get_character_body_size(skill_owner)
	#self.ATTACK_SIZE = base_attack_size*Vector2(min(current_position.x, current_position.y), min(current_position.x, current_position.y))
	#self.DISTANCE = Vector2(25,0)
	#self.attack_collision_indicatior = Collision.create_rectangle(ATTACK_SIZE+self.DISTANCE,skill_owner.global_position)
	#
	#collision_layer =  3 | 1 | 4
	#collision_mask = 3 | 1 | 4
	#if(body is Player):
		#self.ATTACK_WARNING = 0.0
	#else:
		#self.add_child(self.attack_collision_indicatior)
		#self.ATTACK_WARNING = 1.5
	#
	#self.attack_duration = self.ATTACK_WARNING


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
	print(DISTANCE)
	var body_pos = body.global_position
	var attack_stats = AttackStats.new(damage, DISTANCE, body_pos, 2, 5, Util.direction(body), ATTACK_SIZE)
	#var attack_sprite = Sprite.create_sprite(ANIMATED_STAR, ATTACK_SIZE, body_pos)
	var scene_instance = ANIMATED_STAR.instantiate()
	scene_instance.position = body_pos
	var attack = CreateAttack.new(scene_instance, attack_stats, body)
	get_tree().root.add_child(attack)
