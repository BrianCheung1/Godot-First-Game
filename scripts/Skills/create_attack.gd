extends Area2D

class_name CreateAttack

#var color_rect = ColorRect.new()

var logger = Logger.new("[Create Attack]")
var skillOwner
var sprite
var collision_shape
var attack_stats:AttackStats
var hit_body
var playing = false

func _init(sprite,attack_stats:AttackStats, body):
	self.attack_stats = attack_stats
	self.skillOwner = body
	self.collision_shape = collision_shape
	
	global_position = attack_stats.GLOBAL_POSITION - Vector2(0, attack_stats.GLOBAL_POSITION.y)
	self.sprite = sprite
	self.collision_shape = Collision.create_rectangle(self.attack_stats.ATTACK_SIZE,attack_stats.GLOBAL_POSITION)
	attach_collision_area()


func attach_collision_area():
	collision_layer =  3 | 1 | 4
	collision_mask = 3 | 1 | 4

	self.body_entered.connect(_on_body_entered)
	self.add_child(collision_shape)
	if(sprite != null):
		if(sprite is AnimatedSprite2D):
			sprite.play("default")
		self.add_child(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attack_stats.ATTACK_DURATION >0):
		attack_stats.ATTACK_DURATION -= delta
		if(!self.playing):
			move_attack(delta)
		return

	if(!self.playing):
		queue_free()

func move_attack(delta):
	#color_rect.position.y += self.skill_range.y* delta * self.speed_multiplier
	if(attack_stats.ATTACK_DIRECTION == "Right"):
		self.sprite.position.x -=  abs(attack_stats.SKILL_RANGE.x * delta  * attack_stats.SPEED_MULTIPLIER)
		collision_shape.position.x -= abs(attack_stats.SKILL_RANGE.x * delta * attack_stats.SPEED_MULTIPLIER)
		#color_rect.position.x -=  abs(self.skill_range.x * delta* self.speed_multiplier)
		return
	if(attack_stats.ATTACK_DIRECTION):
		self.sprite.position.x +=  abs(attack_stats.SKILL_RANGE.x * delta * attack_stats.SPEED_MULTIPLIER)
		collision_shape.position.x += abs(attack_stats.SKILL_RANGE.x * delta * attack_stats.SPEED_MULTIPLIER)
	#color_rect.position.x +=  abs(self.skill_range.x * delta* self.speed_multiplier)
	if(attack_stats.ATTACK_DIRECTION):
		self.sprite.position.y += abs(attack_stats.SKILL_RANGE.y * delta * attack_stats.SPEED_MULTIPLIER)
		collision_shape.position.y += abs(attack_stats.SKILL_RANGE.y * delta * attack_stats.SPEED_MULTIPLIER)
	if(attack_stats.ATTACK_DIRECTION):
		self.sprite.position.y -= abs(attack_stats.SKILL_RANGE.y * delta * attack_stats.SPEED_MULTIPLIER)
		collision_shape.position.y -= abs(attack_stats.SKILL_RANGE.y * delta * attack_stats.SPEED_MULTIPLIER)

func _on_body_entered(body):
	if(!self.skillOwner):
		return
	if(body is Player and self.skillOwner is Monster2D):
		if(sprite is AnimatedSprite2D):
			body.hit(attack_stats.DAMAGE)
			handle_on_hit(body)
			return
		
		queue_free()
		logger.print("Attacked Body Player")
		return
		
	if(self.skillOwner is Player and body is Monster2D):
		if(sprite is AnimatedSprite2D):
			body.hit(attack_stats.DAMAGE)
			handle_on_hit(body)
			return
		body.hit(attack_stats.DAMAGE)
		queue_free()
		logger.print("Attacked Body Monster")
		
		return
	
	if(self.skillOwner is Player and body is SlimeBoss):
		logger.print("Attacked Body Monster")
		if(sprite is AnimatedSprite2D):
			body.hit(attack_stats.DAMAGE)
			handle_on_hit(body)
			return
		body.hit(attack_stats.DAMAGE)
		queue_free()
		return
	
func handle_on_hit(body):
	self.playing = sprite.is_playing()
	sprite.play("on_hit")
	sprite.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished():
	queue_free()
