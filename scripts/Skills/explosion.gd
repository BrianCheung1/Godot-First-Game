extends Area2D

class_name Explosion

var logger = Logger.new("[Explosion]")

var body

@onready var attackTexture:Texture = preload("res://assets/sprites/explosion-1.png")

var attack_size = 10
var ATTACK_WARNING = 1.5
var attack_duration = ATTACK_WARNING
var activated = false
var damage = 5

var collision_shape = CollisionShape2D.new()

var attackIndicator 

func get_character_body_size(character_body: CharacterBody2D) -> Vector2:
	var collision_shape = find_collision_shape(character_body)
	if collision_shape:
		var shape = collision_shape.shape
		if shape is RectangleShape2D:
			return shape.extents * 2  # RectangleShape2D extents are half-sizes
		elif shape is CircleShape2D:
			return Vector2(shape.radius * 2, shape.radius * 2)
		elif shape is CapsuleShape2D:
			return Vector2(shape.radius * 2, shape.height + shape.radius * 2)
		# Add other shape types if needed
	return Vector2.ZERO

func find_collision_shape(node: Node) -> CollisionShape2D:
	for child in node.get_children():
		if child is CollisionShape2D:
			return child
	return null

func spawn_attack():
	#logger.print("Creating new Explosion")
	var current_position = get_character_body_size(body)
	var attack_size = Vector2(100,15)
	var skill_range = Vector2(0,0)
	var attack_duration = .25
	var speed_multiplier = 5
	var position = body.global_position
	var is_facing_right = false
	if(body is Player):
		is_facing_right = body.is_facing_right
	else:
		is_facing_right= (body.direction== -1)
	
	var attack = CreateAttack.new(attackTexture,attack_size, damage, skill_range, position, attack_duration, speed_multiplier, body, is_facing_right)
	get_tree().root.add_child(attack)

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(attack_duration > 0) && !activated:
		attack_duration-=delta
		AttackIndicator.create_from_collisionshape2d(body,ATTACK_WARNING,find_collision_shape(body), AttackIndicator.Type.Fade).go()
		return
		
	if(attack_duration <= 0) && !activated:
		#logger.print("Explosion Activated")
		spawn_attack()
		activated = true
	

func activate():
	#logger.print(["Explosion Activated"])
	attack_duration = ATTACK_WARNING
	activated = false

func _init(skill_owner):
	body = skill_owner
	if(body is Player):
		ATTACK_WARNING = 0
