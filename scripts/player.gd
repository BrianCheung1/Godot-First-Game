extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt

<<<<<<< Updated upstream
var SPEED = 130.0
var JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var MAX_JUMP_COUNT = 1
=======
const MAX_JUMP_COUNT = 1
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var _items: Array[Item] = [null, null, null, null, null]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
>>>>>>> Stashed changes
var jump_count = 0
var is_alive = true
var direction
var is_jumping

func _ready():
	# Give the user some starting items for testing
	add_item(GravityPotion.new(self, 2), 0)
	add_item(BlinkPotion.new(self, 4), 1)
	print_items()
	
func _physics_process(delta):
	# Add the gravity.	
	velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	is_jumping = Input.is_action_just_pressed("jump")
	if Input.is_action_pressed("reload"):
		get_tree().reload_current_scene()
		
	if not is_alive:
		velocity.x = direction * 0

	if is_alive:
		if jump_count < MAX_JUMP_COUNT and is_jumping:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jump.play()
			
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
				
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	process_items()
	move_and_slide()

<<<<<<< Updated upstream
=======
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
		if _items[i] != null and _items[i].count == 0:
			_items[i] = null
	if activated:
		print_items()
>>>>>>> Stashed changes
