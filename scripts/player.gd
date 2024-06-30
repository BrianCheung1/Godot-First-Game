extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_animation = $AttackAnimation
@onready var animation_player = $AnimationPlayer
@onready var jump_audio = $JumpAudio
@onready var hurt_audio = $HurtAudio
@onready var damage_audio = $DamageAudio
@onready var aura: Aura = $AuraArea2D
@onready var inventory = $CanvasLayer/InventoryGui
@onready var death_timer = $DeathTimer
@onready var camera = $Camera2D
@onready var hitbox: CollisionShape2D = $Area2D/CollisionShape2D

@export var gravity_potion_count:int
@export var blink_potion_count:int
@export var suck_potion_count:int
@export var kill_potion_count:int
@export var enable_flash_jump:bool
@export var enable_aura:bool
@export var enable_roll:bool
@export var is_dev_mode:bool = false

var flash_jump_effect = preload("res://scenes/effect_scenes/flash_jump.tscn")

# Constants
const MAX_HP = 100
const MAX_JUMP_COUNT = 1
const SPEED = 130.0
const FLASH_JUMP_Y_VELOCITY_BOOST = -150
const FLASH_JUMP_X_VELOCITY_BOOST = SPEED * 1.8
const INVINCIBILITY_TIME = 0.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()

# Signals
signal ON_DEATH
signal ON_HIT

# States
var hp
var jump_velocity = -300.0
var jump_count = 0
var is_alive = true
var is_flash_jump = false
var is_flash_jump_up = false
var is_rolling = false
var is_rolling_cooldown = false
var is_sliding_to = 0
var is_sliding = false
var invincibility_time_left = 0
var is_attacking = false
var attack_damage = 50

# Computed Getters
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
	hp = MAX_HP
	
	# Give the user some starting items for testing
	inventory.add_item(GravityPotion.new(self, gravity_potion_count)) #mimic adding new item for testing
	inventory.add_item(GravityPotion.new(self, gravity_potion_count)) #mimic adding new item for testing
	inventory.add_item(BlinkPotion.new(self, blink_potion_count)) #mimic adding new item for testing
	inventory.add_item(SuckCoinPotion.new(self, suck_potion_count)) #mimic adding new item for testing
	inventory.add_item(KillAllPotion.new(self, kill_potion_count)) #mimic condense item for testing
	#inventory.swap_item_index(0,7) #mimic swap items for testing
	aura.enable(enable_aura)
	
func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		inventory.toggle_visibility()
		return
	inventory.process_items()
	
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_input: float = Input.get_axis("move_left", "move_right")
	var direction_input_y: float = Input.get_axis("move_up", "move_down")
	var has_jump_input: bool = Input.is_action_pressed("jump")
	var has_roll_input: bool = Input.is_action_pressed("roll")
	var has_attack_input: bool = Input.is_action_pressed("attack")
	var flash_jump_input: float = Input.is_action_just_pressed("flash_jump")
	
	if is_dev_mode:
		velocity.x = direction_input * SPEED * 2
		velocity.y = direction_input_y * SPEED * 2
	else:
		if Input.is_action_just_pressed("reload"):
			get_tree().reload_current_scene()
			PlayerVariables.player_resets +=1
		
		# Return early if deadge
		if not is_alive:
			velocity.x = 0
			return
			
		# Handle iFrame
		invincibility_time_left -= delta
		animated_sprite.modulate = Color(3,3,3,3) if invincibility_time_left > 0 else Color(1,1,1,1)
		
		# Rules that must be true if you are touching the floor
		if is_on_floor():
			# Don't allow sliding after flash jump lands
			if is_flash_jump or is_flash_jump_up:
				velocity.x = 0
			jump_count = 0
			is_flash_jump = false
			is_flash_jump_up = false
			velocity.y = 0
			
		# Handle animations
		if is_attacking:
			var attack_animation = "sword_slash_left" if is_facing_right else "sword_slash_right"
			animation_player.play(attack_animation)
		if is_jumping:
			animated_sprite.play("jump")
		elif is_rolling:
			animated_sprite.play("roll")
		else:
			var floor_animation = "idle" if direction_input == 0 else "run"
			animated_sprite.play(floor_animation)
		# (Can't change direction when flash jumping) Flip sprite depending on the direction_input, keep previous value if no input, otherwise check the input direction
		if not is_flash_jump and not is_rolling:
			animated_sprite.flip_h = animated_sprite.flip_h if direction_input == 0 else direction_input == -1
		# Handle Y
		# Handle gravity
		velocity.y += gravity * delta
		# Handle jumps
		if jump_count < MAX_JUMP_COUNT and has_jump_input:
			velocity.y = jump_velocity
			jump_count += 1
			jump_audio.play()
		elif !has_jump_input:
			# Start falling if the player releases the jump button
			velocity.y = max(velocity.y, 0)
		# Handle flash jumps
		if enable_flash_jump and (is_jumping or not is_on_floor()) and flash_jump_input and not is_flash_jump:
			hit(5)
			if direction_input:
				velocity.y = FLASH_JUMP_Y_VELOCITY_BOOST
				is_flash_jump = true
			else:
				velocity.y = FLASH_JUMP_Y_VELOCITY_BOOST * 2
				is_flash_jump_up = true
			spawn_flash_jump_effect()
		#Handle rolling
		if enable_roll and is_on_floor() and has_roll_input and not is_rolling and not is_rolling_cooldown:
			invincibility_time_left = 999999
			is_rolling = true
			is_rolling_cooldown = true
			set_collision_layer_value(2, false)
		#Handle attacking
		if has_attack_input and not is_attacking:
			is_attacking = true
		# Handle X
		if is_flash_jump:
			velocity.x = (-1 if is_facing_right else 1) * FLASH_JUMP_X_VELOCITY_BOOST
		elif is_rolling:
			velocity.x = (-1 if is_facing_right else 1) * SPEED
		elif direction_input and not is_sliding:
			is_sliding_to = 0
			velocity.x = direction_input * SPEED
		elif is_sliding:
			is_sliding_to = -130 if is_facing_right else 130
			velocity.x = move_toward(velocity.x, is_sliding_to*2, SPEED)
		else:
			is_sliding_to += -sign(is_sliding_to)
			velocity.x = move_toward(velocity.x, is_sliding_to, SPEED)
		
	move_and_slide()

func _process(delta):
	pass

func hit(damage: int):
	if not is_alive or invincibility_time_left > 0: return
	invincibility_time_left = INVINCIBILITY_TIME
	
	var damage_label = Hit.create_new_player_hit(hitbox, damage)
	Util.add_node(self, damage_label)
	
	hp -= damage
	if hp <= 0:
		die()
		return
	damage_audio.play()
	
func die():
	is_alive = false
	animated_sprite.play("death")
	hurt_audio.play()
	aura.enable(false)
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, true)
	$DeathTimer.start()
	
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

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "roll":
		is_rolling = false
		invincibility_time_left = 0
		set_collision_layer_value(2, true)
		$RollCooldownTimer.start()

		
func _on_roll_cooldown_timer_timeout():
	is_rolling_cooldown = false
	
func _on_death_timer_timeout():
	get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "sword_slash_right" or anim_name == "sword_slash_left":
		is_attacking = false
		animation_player.play("RESET")


func _on_attack_hit_box_body_entered(body):
	if body.is_in_group("wizard") or body.is_in_group("slime"):
		body.hit(attack_damage)
