extends Node2D
class_name IndicatorAttackBase

@onready var animated_sprites: Array[AnimatedSprite2D] = []
@onready var hitbox: CollisionShape2D

@export var show_indicator_duration: float

var delay_timer: SceneTreeTimer

func _ready():
	for x in animated_sprites:
		x.hide()
	animated_sprites[0].animation_finished.connect(on_animation_finished)
	hitbox.disabled = true

func go():
	do_positioning()
	delay_timer = get_tree().create_timer(show_indicator_duration)
	delay_timer.timeout.connect(on_timeout)
	AttackIndicator.create_from_collisionshape2d(self, delay_timer.time_left - 0.05, hitbox, AttackIndicator.Type.Fade).go()
	
# Should be overriden by subclasses
func do_positioning():
	pass

func on_timeout():
	for x in animated_sprites:
		x.show()
		x.play()
	hitbox.disabled = false

func on_animation_finished():
	hitbox.disabled = true
	queue_free()
