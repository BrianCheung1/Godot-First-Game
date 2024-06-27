extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var rollback_synchronizer = $RollbackSynchronizer
@onready var jump = $jump
@onready var hurt = $hurt

var MAX_JUMP_COUNT = 1
var SPEED = 130.0
var JUMP_VELOCITY = -300.0
var _items: Array[Item] = [null, null, null, null, null]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _respawning = false
var jump_count = 0
var is_alive = true
var is_sliding_to = 0
var is_sliding = false
var is_facing_right: bool:
	get:
		return true if animated_sprite.flip_h else false
var level: Node:
	get: 
		return get_parent()

@export var input:PlayerInput

@export var player_id:=1:
	set(id):
		player_id = id
		input.set_multiplayer_authority(id)

func _ready():
	print("Player %s Added to scene" % player_id)
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled=false
	rollback_synchronizer.process_settings()
		
func _apply_animations(_delta):
		var direction = input.input_direction
		var is_jumping = input.input_jump > 0
			#Play animations
		if is_alive:
			if is_on_floor() and not is_jumping:
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
	#_force_update_is_on_floor()
	# Get the input direction and handle the movement/deceleration.
	var is_jumping = input.input_jump > 0
	var direction = input.input_direction
	var reload = input.reload
	
	if reload:
		position = MultiplayerManager.respawn_point
	if not is_alive:
		velocity.x = direction * 0
		
	if is_alive:
		# Add the gravity.	
		velocity.y += gravity * delta
		#elif input.input_jump > 0:
			#velocity.y = JUMP_VELOCITY * input.input_jump
			#jump.play()
			#print("jumped")
		if jump_count < MAX_JUMP_COUNT and input.input_jump > 0:
			print("test")
			velocity.y = JUMP_VELOCITY * input.input_jump
			jump_count += 1
			jump.play()
		#elif input.input_jump <= 0 and velocity.y < 0:
			#if velocity.y < 0:
				#velocity.y += gravity * delta
		elif is_on_floor():
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
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor

func _rollback_tick(delta, tick, is_fresh):
	if not _respawning:
		_apply_movement_from_input(delta)
	else:
		_respawning = false
		position = MultiplayerManager.respawn_point
		velocity = Vector2.ZERO
		$TickInterpolator.teleport()
		await get_tree().create_timer(0.5).timeout
		is_alive = true
	
func _force_update_is_on_floor():
	var old_velocity = velocity
	velocity = Vector2.ZERO
	move_and_slide()
	velocity = old_velocity
	
func _process(delta):
	if not multiplayer.is_server() or MultiplayerManager.host_mode_enabled:
		_apply_animations(delta)

func is_dead():
	print("player is dead")
	is_alive=false
	animated_sprite.play("death")
	hurt.play()
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, true)
	$RespawnTimer.start()
	
func _on_respawn_timer_timeout():
	print("respawned")
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, false)
	_respawning = true

