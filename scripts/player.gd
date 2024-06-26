extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt

@export var gravity_potion_count:int
@export var blink_potion_count:int
@export var suck_potion_count:int
@export var kill_potion_count:int

var MAX_JUMP_COUNT = 1
var SPEED = 130.0
var JUMP_VELOCITY = -300.0
var _items: Array[Item] = [null, null, null, null, null]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var is_alive = true
var direction
var is_jumping
var is_sliding_to = 0
var is_sliding = false
var is_facing_right: bool:
	get:
		return true if animated_sprite.flip_h else false
var level: Node:
	get: 
		return get_parent()
		
func _ready():
	# Give the user some starting items for testing
	add_item(GravityPotion.new(self, gravity_potion_count), 0)
	add_item(BlinkPotion.new(self, blink_potion_count), 1)
	add_item(SuckCoinPotion.new(self, suck_potion_count), 2)
	add_item(KillAllPotion.new(self, kill_potion_count), 3)
	print_items()
	
func _physics_process(delta):
	# Add the gravity.	
	velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	is_jumping = Input.is_action_pressed("jump")
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		PlayerVariables.player_resets +=1
		
	if not is_alive:
		velocity.x = direction * 0

	if is_alive:
		if jump_count < MAX_JUMP_COUNT and is_jumping:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jump.play()
		if !is_jumping and velocity.y < 0:
			while velocity.y < 0:
				velocity.y += delta
		#Play animations
		if is_on_floor() and not is_jumping:
			jump_count = 0
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		elif is_jumping:
			animated_sprite.play("jump")
			
		
		#Flip sprite depending on the direction left or right
		if direction == -1:
			animated_sprite.flip_h = true
		if direction == 1:
			animated_sprite.flip_h = false
				
		if direction and not is_sliding:
			is_sliding_to = 0
			velocity.x = direction * SPEED
		elif is_sliding:
			is_sliding_to = -130 if is_facing_right else 130
			velocity.x = move_toward(velocity.x, is_sliding_to*2, SPEED)
		else:
			if is_sliding_to > 0:
				is_sliding_to -= 1
			elif is_sliding_to < 0:
				is_sliding_to += 1
			velocity.x = move_toward(velocity.x, is_sliding_to, SPEED)
	process_items()
	move_and_slide()

func print_items():
	print("Listing all items:")
	for item in _items:
		print("   " + str(item))
	
func add_item(item: Item, index: int):
	if index >= _items.size():
		push_error("Error add item: index >= _items.size()")
		return
	_items[index] = item
	
func process_items():
	var activated = false
	# Input and activate
	if Input.is_action_just_pressed("item1") and _items[0] != null:
		_items[0].activate()
		activated = true
	if Input.is_action_just_pressed("item2") and _items[1] != null:
		_items[1].activate()
		activated = true
	if Input.is_action_just_pressed("item3") and _items[2] != null:
		_items[2].activate()
		activated = true
	if Input.is_action_just_pressed("item4") and _items[3] != null:
		_items[3].activate()
		activated = true
	if Input.is_action_just_pressed("item5") and _items[4] != null:
		_items[4].activate()
		activated = true
	# Remove from inventory if used up
	for i in _items.size():
		if _items[i] != null and _items[i].IsEmpty:
			_items[i] = null
	if activated:
		print_items()

func _on_area_2d_body_entered(body):
	if body is TileMap:
		print("Enter tile")
		is_sliding = true
		
func _on_area_2d_body_exited(body):
	if body is TileMap:
		print("Left tile")
		is_sliding = false
		

func _on_area_2d_2_body_entered(body):
	if body is TileMap:
		print("1")
