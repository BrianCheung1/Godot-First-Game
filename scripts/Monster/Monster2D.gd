extends Node2D
class_name Monster2D

var enemy_death_effect = preload("res://scenes/effect_scenes/smoke.tscn")
var enemy_hit_scene = preload("res://scenes/effect_scenes/enemy_hit.tscn")

@onready var collision_node = $Killzone/CollisionShape2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var on_death_audio = $OnDeathAudio

@export var hp: int
@export var speed: int
var direction = 1

func _init():
	pass
	
func _ready():
	if MultiplayerManager.multiplayer_mode_enabled:
		set_process(false)
		NetworkTime.on_tick.connect(_tick)
	on_death_audio.connect("finished", func(): queue_free())
	
func _tick(delta, tick):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta
	
func hit(damage: int):
	# Spawn the damage numbers
	var damage_label = Hit.create_new_hit(collision_node, damage)
	add_node(damage_label)
	
	hp -= damage
	print(str(self) + ": hit({damage})".format({ "damage": damage }))
	if hp <= 0:
		die()
	
func die():
	print(str(self) + ": die()")
	on_death_audio.play()
	animated_sprite.hide()
	collision_node.disabled = true
	# Death effect
	var death_effect = spawn_and_add_node(enemy_death_effect)
	death_effect.global_position = self.global_position
	
func _to_string():
	return "Monster [HP={HP}]".format({ "HP": hp })

func add_node(node: Node):
	get_parent().add_child(node)
	
func spawn_and_add_node(resource: Resource):
	var node = resource.instantiate()
	add_node(node)
	return node
	
