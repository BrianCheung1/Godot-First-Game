extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt
@onready var inventory = $InventoryGui

@export var gravity_potion_count:int
@export var blink_potion_count:int
@export var suck_potion_count:int
@export var kill_potion_count:int
@export var enable_flash_jump:bool

var flash_jump_effect = preload("res://scenes/effect_scenes/flash_jump.tscn")

var MAX_JUMP_COUNT = 1
var SPEED = 130.0
var JUMP_VELOCITY = -300.0
var FLASH_JUMP_Y_VELOCITY_BOOST = -150
var FLASH_JUMP_X_VELOCITY_BOOST = SPEED * 1.8
var _items: Array[Item] = [null, null, null, null, null]
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var is_alive = true
var is_flash_jump = false
var is_sliding_to = 0
var is_sliding = false
var is_facing_right: bool:
	get:
		return true if animated_sprite.flip_h else false
var level: Node:
	get: 
		return get_parent()
var is_jumping: bool:
	get: 
		return jump_count > 0

func _ready():
	# Give the user some starting items for testing
	inventory.add_item(GravityPotion.new(self, gravity_potion_count))
	inventory.add_item(BlinkPotion.new(self, blink_potion_count))
	inventory.add_item(SuckCoinPotion.new(self, suck_potion_count))
	inventory.add_item(KillAllPotion.new(self, kill_potion_count))
	
func _physics_process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		PlayerVariables.player_resets +=1
	
	# Return early if deadge
	if not is_alive:
		velocity.x = 0
		return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_input: float = Input.get_axis("move_left", "move_right")
	var has_jump_input: bool = Input.is_action_pressed("jump")
	var flash_jump_input: bool =  Input.is_action_just_pressed("flash_jump")
		
	# Rules that must be true if you are touching the floor
	if is_on_floor():
		# Don't allow sliding after flash jump lands
		if is_flash_jump:
			velocity.x = 0
		jump_count = 0
		is_flash_jump = false
		velocity.y = 0
		
	# Handle animations
	if is_jumping:
		animated_sprite.play("jump")
	else:
		var floor_animation = "idle" if direction_input == 0 else "run"
		animated_sprite.play(floor_animation)
	# (Can't change direction when flash jumping) Flip sprite depending on the direction_input, keep previous value if no input, otherwise check the input direction
	if not is_flash_jump:
		animated_sprite.flip_h = animated_sprite.flip_h if direction_input == 0 else direction_input == -1
	
	# Handle Y
	# Handle gravity
	velocity.y += gravity * delta
	# Handle jumps
	if jump_count < MAX_JUMP_COUNT and has_jump_input:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		jump.play()
	elif !has_jump_input:
		# Start falling if the player releases the jump button
		velocity.y = max(velocity.y, 0)
	# Handle flash jumps
	if enable_flash_jump and (is_jumping or not is_on_floor()) and flash_jump_input and not is_flash_jump:
		print("Flash jump")
		is_flash_jump = true
		spawn_flash_jump_effect()
		velocity.y = FLASH_JUMP_Y_VELOCITY_BOOST

	# Handle X
	if is_flash_jump:
		velocity.x = (-1 if is_facing_right else 1) * FLASH_JUMP_X_VELOCITY_BOOST
	elif direction_input and not is_sliding:
		is_sliding_to = 0
		velocity.x = direction_input * SPEED
	elif is_sliding:
		is_sliding_to = -130 if is_facing_right else 130
		velocity.x = move_toward(velocity.x, is_sliding_to*2, SPEED)
	else:
		is_sliding_to += -sign(is_sliding_to) 
		velocity.x = move_toward(velocity.x, is_sliding_to, SPEED)
		
	inventory.process_items()
	move_and_slide()
		
func spawn_flash_jump_effect():
	var node: AnimatedSprite2D = flash_jump_effect.instantiate()
	get_parent().add_child(node)
	node.global_position = self.global_position
	node.global_position.x += 20 if is_facing_right else -20
	node.flip_h = is_facing_right
		

func _on_area_2d_body_entered(body):
	if body is TileMap:
		print("Enter tile")
		is_sliding = true
		
func _on_area_2d_body_exited(body):
	if body is TileMap:
		print("Left tile")
		is_sliding = false
		
func _on_camera_2d_ready():
	pass # Replace with function body.
