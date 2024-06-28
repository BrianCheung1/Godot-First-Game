extends Monster2D
class_name Slime

const SPEED = 60
var direction = 1
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	if MultiplayerManager.multiplayer_mode_enabled:
		set_process(false)
		NetworkTime.on_tick.connect(_tick)
		
		
func _tick(delta, tick):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta
	
# Overrides the original die function
func die():
	# Custom death effect for the slime (Try commenting this line out and see what happens)
	# enemy_death_effect = preload("res://scenes/effect_scenes/explosion.tscn")
	# Call the parent die function in Monster2D.gd
	super.die()
	
