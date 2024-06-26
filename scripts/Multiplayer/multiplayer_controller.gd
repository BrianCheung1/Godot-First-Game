extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt

var MAX_JUMP_COUNT = 1
var SPEED = 130.0
var JUMP_VELOCITY = -300.0
var _items: Array[Item] = [null, null, null, null, null]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var is_alive = true
var direction
var reload
var _is_on_floor = true
var do_jump 
var is_jumping = false
var is_sliding_to = 0
var is_sliding = false
var is_facing_right: bool:
	get:
		return true if animated_sprite.flip_h else false
var level: Node:
	get: 
		return get_parent()

@export var player_id:=1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func _ready():
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled=false
		
		
func _apply_animations(delta):
			#Play animations
		if is_alive:
			if _is_on_floor and not do_jump:
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
			

func _apply_movement_from_input(delta):
	# Add the gravity.	
	velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = %InputSynchronizer.input_direction
	reload = %InputSynchronizer.reload
	if reload:
		position = MultiplayerManager.respawn_point
	if not is_alive:
		velocity.x = direction * 0
		
	if is_alive:
		if jump_count < MAX_JUMP_COUNT and do_jump:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jump.play()
		if !do_jump and velocity.y < 0:
			while velocity.y < 0:
				velocity.y += delta
		if is_on_floor() and !do_jump:
			jump_count = 0
			
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
	move_and_slide()
	
func _physics_process(delta):
	if multiplayer.is_server():
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
	if not multiplayer.is_server() or MultiplayerManager.host_mode_enabled:
		_apply_animations(delta)

func is_dead():
	print("player is dead")
	is_alive = false
	$AnimatedSprite2D.play("death")
	$hurt.play()
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, true)
	$RespawnTimer.start()
	
func _on_respawn_timer_timeout():
	print("respawned")
	position = MultiplayerManager.respawn_point
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, false)
	is_alive = true

