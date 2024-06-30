extends Label
class_name Hit

const FLOAT_PIXEL_AMOUNT = 15

var target_collision: CollisionShape2D
var lifetime
var grow_until
var height: float:
	get:
		return size.y
var width: float:
	get:
		return size.x

func _ready():
	lifetime = 0.6
	#grow_until = lifetime * 0.9
	
	# Position the damage above the object's head
	var target_head;
	if target_collision.shape is RectangleShape2D:
		var rect_size = Util.try_get_rectangle_size(target_collision)
		target_head = Vector2(
			target_collision.global_position.x - rect_size.x / 2,
			target_collision.global_position.y - rect_size.y
		)
	else:
		print("Collision shape not supported: create_new_hit")
	global_position = target_head
		

func _process(delta):
	lifetime -= delta
	global_position.y = global_position.y - (FLOAT_PIXEL_AMOUNT * delta)
	
	# Grow big then grow small
	#if lifetime > grow_until:
		#scale = scale + Vector2(2, 2) * delta
		
	if lifetime < 0:
		queue_free()
	

#const MY_SCENE = preload("res://scenes/effect_scenes/enemy_hit.tscn")
static func create_new_hit(collision_shape: CollisionShape2D, damage: int) -> Label:
	var hit_scene = load("res://scenes/effect_scenes/enemy_hit.tscn")
	var hit_label: Hit = hit_scene.instantiate()
	hit_label.text = str(damage)
	hit_label.target_collision = collision_shape
	return hit_label
	
