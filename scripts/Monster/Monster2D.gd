extends CharacterBody2D
class_name Monster2D

var enemy_death_effect = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()

@onready var item_resource = load("res://scenes/item_loot.tscn")
@onready var ray_cast_right = $RayCastRight
@onready var damage_collision: CollisionShape2D = $DamageZone/CollisionShape2D
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var on_death_audio: AudioStreamPlayer2D = $OnDeathAudio
@onready var on_damage_audio = $DamageAudio
@onready var mini_hpbar: ProgressBar = $MiniHealthbar
@onready var ray_cast_down = $RayCastDown
@export var hp: int = 100
@export var speed: int = 60
signal damage_taken(new_health)


var is_flashing = false
var dead = false
var direction = 1
var enemy_hit_sound_node: AudioStreamPlayer
var is_facing_right = false

func _init():
	pass
	
func _ready():
	if MultiplayerManager.multiplayer_mode_enabled:
		set_process(false)
		NetworkTime.on_tick.connect(_tick)
	on_death_audio.finished.connect(cleanup)
	# Set up hp bar
	mini_hpbar.min_value = 0
	mini_hpbar.max_value = hp
	mini_hpbar.value = hp
	mini_hpbar.hide()
	#AttackIndicator.create_from_collisionshape2d(self, 999, damage_collision).go()
	# Hide shader flash
	if animated_sprite.material:
		animated_sprite.material.set_shader_parameter("flash_modifier", 0);
	
func _tick(delta, tick):
	if ray_cast_right != null and ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_right != null and ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta

func _process(delta):
	if ray_cast_right != null and ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_right != null and ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta

func physics_process_default(delta):
	if velocity.x != 0:
		is_facing_right = true if velocity.x > 0 else false
	animated_sprite.flip_h = false if is_facing_right else true
	velocity.y += gravity * delta

func _physics_process(delta):
	physics_process_default(delta)
	move_and_slide()
	pass
	
func flash():
	if is_flashing:
		return
	var material: ShaderMaterial = animated_sprite.material
	if material == null:
		print("monster has no flash shader")
		return
	var is_flashing = true
	material.set_shader_parameter("flash_modifier", 0.8);
	await get_tree().create_timer(0.15).timeout
	material.set_shader_parameter("flash_modifier", 0);
	is_flashing = false
	
	
func cleanup():
	queue_free()
	
func hit(damage: int):
	if dead: return
	# Spawn the damage numbers
	var damage_label = Hit.create_new_enemy_hit(damage_collision, damage)
	Util.add_node(self, damage_label)
	
	flash()
	hp -= damage
	mini_hpbar.value = max(0, hp)
	mini_hpbar.show()
	print(str(self) + ": hit({damage})".format({ "damage": damage }))
	if hp <= 0:
		die()
		return
	on_damage_audio.play()
	emit_signal("damage_taken", hp)
	

func generate_item_node(item_name:String):
	# Call the parent die function in Monster2D.gd
	var item_loot:ItemLoot = item_resource.instantiate()
	item_loot.item_name = item_name
	item_loot.global_position = global_position - Vector2(0, 10)
	Util.add_node(self, item_loot)
	
func die():
	if dead: return
	print(str(self) + ": die()")
	dead = true
	mini_hpbar.hide()
	animated_sprite.hide()
	damage_collision.disabled = true
	
	spawn_death_effect()
	# On death audio (should free up resources after the audio is finished playing)
	if on_death_audio.has_stream_playback():
		on_death_audio.play()
	else:
		cleanup()

func spawn_death_effect():
	if not enemy_death_effect: return
	var death_effect = Util.spawn_and_add_node(self, enemy_death_effect)
	var monster_size = Util.try_get_rectangle_size(damage_collision)
	death_effect.global_position = Vector2(global_position.x, global_position.y + monster_size.y)
	
func _to_string():
	return "Monster [HP={HP}]".format({ "HP": hp })
