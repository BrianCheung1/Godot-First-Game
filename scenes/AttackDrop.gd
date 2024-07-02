extends Panel

@onready var collision_shape = CollisionShape2D.new()
@onready var color_rect = ColorRect.new()
@onready var sword_sprite = Sprite2D.new()

@onready var shape = RectangleShape2D.new()

var ATTACK_DURATION = 10

var current_duration = 10

var fall_speed = 100.0

var logger = Logger.new("[Falling Attack]")

var damage = 10

var attack_size = 10


func spawn_attack():
	reset_position()
	add_child(color_rect)
	#add_child(collision_shape)
	add_child(sword_sprite)

func reset_position():
	shape.extents = Vector2(attack_size/2, attack_size/2)
	# Create a ColorRect node to visualize the collision shape
	color_rect.color = Color(1, 0, 0)  # Red color
	color_rect.size = Vector2(attack_size, attack_size)
	
	collision_shape.shape = shape
	# Position the ColorRect under the panel to match the collision shape
	color_rect.position = Vector2(0, size.y)
	collision_shape.position = Vector2(attack_size/2,size.y + attack_size/2)
	
	sword_sprite.position = Vector2(attack_size/2,size.y + attack_size/2)

# Called when the node enters the scene tree for the first time.
func _ready():
	var area = Area2D.new()
	area.add_child(collision_shape)
	add_child(area)
	
	area.collision_layer = 2
	area.collision_mask = 2
	
	sword_sprite.texture = load("res://assets/sprites/star.png")
	sword_sprite.scale = Vector2(attack_size,attack_size)/sword_sprite.texture.get_size()
	area.body_entered.connect(_on_body_entered)
	
	spawn_attack()
	
func move_attack(distance):
	# Move the panel down slowly
	sword_sprite.position.y += distance
	collision_shape.position.y += distance  # Adjust the speed as needed
	color_rect.position.y += distance
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(current_duration >= 0):
		move_attack(fall_speed * delta)
		current_duration -= delta
		return
	
	#logger.print("Reset Attack Position")
	current_duration = ATTACK_DURATION
	reset_position()
	

func _on_body_entered(body):
	if(body is Player):
		body.hit(damage)
		logger.print("Entered Body")
	else:
		reset_position()
