extends CharacterBody2D
class_name Monster2D

var enemy_death_effect = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()

@onready var item_resource = load("res://scenes/item_loot.tscn")
@onready var ray_cast_right = $RayCastRight
@onready var damage_collision: CollisionShape2D = $DamageZone/CollisionShape2D
@onready var ray_cast_left = $RayCastLeft
#@onready var animated_sprite = $AnimatedSprite2D
var animated_sprite
@onready var on_death_audio: AudioStreamPlayer2D = $OnDeathAudio
@onready var on_damage_audio = $DamageAudio
@onready var mini_hpbar: ProgressBar = $MiniHealthbar
@onready var ray_cast_down = $RayCastDown
@onready var game_manager = %GameManager

@export var hp: int = 100
@export var speed: int = 60
@export var coins_on_death:int = 10
signal damage_taken(new_health)


var is_flashing = false
var dead = false
var direction = 1
var enemy_hit_sound_node: AudioStreamPlayer
var is_facing_right = false

const possilbe_actions = ["idle", "attack", "walk"]
var ACTION_CD = 2
var current_action_time = 0
var current_action:String
var need_offset = false
var collision_node:CollisionShape2D
var attack_collision:CollisionShape2D
var base_size:Vector2
var attack_direction:String
var attack_padding:Vector2

func _init():
	pass
	
func create_attack_zone():
	self.attack_collision = Collision.create_new_shape_with_modified_extents(self.collision_node, self.attack_padding.x, 0)
	update_attack_collision()
	self.attack_collision.disabled = true
	get_node("DamageZone").add_child(self.attack_collision)
	
func _ready():
	self.animated_sprite = get_node("AnimatedSprite2D")
	self.collision_node = get_node("CollisionShape2D")
	self.base_size = Collision.get_collision_shape_size(self.collision_node)

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
		
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	self.damage_taken.connect(_on_health_changed)

func _on_health_changed(hp):
	if(self.current_action != "attack"):
		self.current_action_time = 0

func update_attack_collision():
	if(self.attack_direction == "Front"):
		if(self.animated_sprite.flip_h == true):
			self.attack_collision.position.x = self.collision_node.position.x - self.attack_padding.x
			return
		self.attack_collision.position.x = self.collision_node.position.x + self.attack_padding.x
		return

func _on_animation_finished():
	if(attack_collision != null):
		attack_collision.disabled = true
	animated_sprite.offset = Vector2(0,0)
	animated_sprite.play("idle")
	self.current_action_time = 0

func find_player():
	var current_player_pos = Util.find_target(self).position
	update_attack_collision()
	if(self.global_position.x > current_player_pos.x):
		animated_sprite.flip_h = true
		direction = -1
		return true

	animated_sprite.flip_h = false
	direction = 1
	return false

	
	
func _tick(delta, tick):
	if ray_cast_right != null and ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_right != null and ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta
	update_attack_collision()

func _process(delta):
	if ray_cast_right != null and ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_right != null and ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if(!ray_cast_down.is_colliding()):
		self.position.y += 1
	position.x += direction * speed * delta
	update_attack_collision()

func physics_process_default(delta):
	if velocity.x != 0:
		is_facing_right = true if velocity.x > 0 else false
	animated_sprite.flip_h = false if is_facing_right else true
	update_attack_collision()
	velocity.y += gravity * delta

func _physics_process(delta):
	if(self.current_action_time > 0):
		self.current_action_time -= delta
	else:
		self.current_action_time = ACTION_CD
		determine_action()
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
	var offset = offset("idle","die")
	self.animated_sprite.offset = offset
	self.animated_sprite.play("die")
	
	print(str(self) + ": die()")
	dead = true
	mini_hpbar.hide()
	damage_collision.disabled = true
	game_manager.add_coins_on_monster_kill(coins_on_death)
	
	animated_sprite.animation_finished.connect(cleanup)
	
	spawn_death_effect()
	# On death audio (should free up resources after the audio is finished playing)
	if on_death_audio.has_stream_playback():
		on_death_audio.play()

func spawn_death_effect():
	if not enemy_death_effect: return
	var death_effect = Util.spawn_and_add_node(self, enemy_death_effect)
	var monster_size = Util.try_get_rectangle_size(damage_collision)
	death_effect.global_position = Vector2(global_position.x, global_position.y + monster_size.y)
	
func _to_string():
	return "Monster [HP={HP}]".format({ "HP": hp })

func offset(idle, off_set_frame)->Vector2:
	var direction = self.find_player()
	
	if(!self.need_offset):
		return Vector2(0,0)
	
	var attack_size = Sprite.get_current_sprite_size(self.animated_sprite, off_set_frame)
	var idle_size = Sprite.get_current_sprite_size(self.animated_sprite, idle)
	
	if(attack_size == idle_size):
		return Vector2(0,0)
	
	if(direction):
		return -((attack_size - idle_size)/2)
	
		
	return (attack_size - idle_size)/2

func determine_action():
	var random_action = self.possilbe_actions[randi_range(0, possilbe_actions.size()-1)]

	match random_action:
		"idle":
			self.speed = 0
			self.animated_sprite.play("idle")
			self.current_action = "idle"
		"attack":
			var offset = offset("idle","attack")
			self.animated_sprite.offset = offset
			self.current_action = "attack"
			self.speed = 0
			if(attack_collision != null):
				attack_collision.disabled = false
			self.animated_sprite.play("attack")
		"walk":
			self.speed = 60
			self.current_action = "walk"
			self.animated_sprite.play("run")
			self.find_player()
