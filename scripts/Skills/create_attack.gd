extends Area2D

class_name CreateAttack

#var color_rect = ColorRect.new()
var attack_sprite = Sprite2D.new()
var shape = RectangleShape2D.new()
var collision_shape = CollisionShape2D.new()

var logger = Logger.new("[Create Attack]")

var damage
var target_size:Vector2
var attack_position:Vector2
var skill_range:Vector2
var duration:float
var speed_multiplier:float
var skillOwner
var is_facing_right

func _init(sprite_texture:Texture, attack_size:Vector2, damage:int, skill_range:Vector2, attack_position:Vector2, duration:float, speed_multiplier:float, body, is_facing_right:bool):
	self.damage = damage
	self.skill_range = skill_range
	self.target_size = attack_size
	self.duration = duration
	self.attack_position = attack_position
	self.speed_multiplier = speed_multiplier
	self.skillOwner = body
	self.is_facing_right = is_facing_right
	
	global_position = attack_position - Vector2(0, attack_position.y)
	attack_sprite.texture = sprite_texture
	attack_sprite.scale = self.target_size/attack_sprite.texture.get_size()
	create_collision_area()


func create_collision_area():
	self.collision_layer =  3 | 1 | 4
	self.collision_mask = 3 | 1 | 4
	shape.extents = Vector2(self.target_size.x/2, self.target_size.y/2)
	#color_rect.color = Color(1, 0, 0)  # Red color
	#color_rect.size = Vector2(self.target_size.x, self.target_size.y)
	#color_rect.position = Vector2(0- (self.target_size.x/2), self.attack_position.y - self.target_size.y)
	collision_shape.shape = shape
	collision_shape.position = Vector2(self.target_size.x/2 - (self.target_size.x/2),self.attack_position.y + self.target_size.y/2  - self.target_size.y)
	attack_sprite.position = Vector2(self.target_size.x/2 - (self.target_size.x/2),self.attack_position.y + self.target_size.y/2  - self.target_size.y)
	
	self.body_entered.connect(_on_body_entered)
	#self.add_child(color_rect)
	self.add_child(collision_shape)
	self.add_child(attack_sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.duration >0):
		self.duration -= delta
		move_attack(delta)
		return
	
	#logger.print("Removed")
	queue_free()

func move_attack(delta):
	attack_sprite.position.y += self.skill_range.y * delta * self.speed_multiplier
	collision_shape.position.y += self.skill_range.y * delta * self.speed_multiplier
	#color_rect.position.y += self.skill_range.y* delta * self.speed_multiplier
	if(self.is_facing_right):
		attack_sprite.position.x -=  abs(self.skill_range.x * delta * self.speed_multiplier)
		collision_shape.position.x -= abs(self.skill_range.x * delta * self.speed_multiplier)
		#color_rect.position.x -=  abs(self.skill_range.x * delta* self.speed_multiplier)
		
		return 
	attack_sprite.position.x +=  abs(self.skill_range.x * delta * self.speed_multiplier)
	collision_shape.position.x += abs(self.skill_range.x * delta * self.speed_multiplier)
	#color_rect.position.x +=  abs(self.skill_range.x * delta* self.speed_multiplier)

func _on_body_entered(body):
	if(!self.skillOwner):
		return
	if(body is Player and self.skillOwner is Monster2D):
		body.hit(damage)
		queue_free()
		logger.print("Attacked Body Player")
		
	if(self.skillOwner is Player and body is Monster2D):
		body.hit(damage)
		queue_free()
		logger.print("Attacked Body Monster")
	
	if(self.skillOwner is Player and body is SlimeBoss):
		body.hit(damage)
		queue_free()
		logger.print("Attacked Body Monster")
