extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_JUMP_COUNT = 1
var jump_count = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	var is_jumping = Input.is_action_just_pressed("jump")
	
	if jump_count < MAX_JUMP_COUNT and is_jumping:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	#Play animations
	if is_on_floor() and not is_jumping:
		jump_count = 0
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
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

	move_and_slide()
