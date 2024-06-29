extends Label
class_name Hit

const FLOAT_PIXEL_AMOUNT = 5
const GROW_BIG_TO_SMALL_AFTER_PERCENT = 0.1

var target_collision: CollisionShape2D
var lifetime
var grow_small_after
var height: float:
	get:
		return size.y
var width: float:
	get:
		return size.x

func _ready():
	lifetime = 1
	grow_small_after = lifetime - (lifetime * GROW_BIG_TO_SMALL_AFTER_PERCENT) # so if lifetime = 1s and GROW_BIG_TO_SMALL_AFTER_PERCENT = 0.3, this would be 0.7
	
	# Position the damage above the object's head
	var target_head;
	if target_collision.shape is RectangleShape2D:
		var rect_size = Util.try_get_rectangle_size(target_collision)
		target_head = Vector2(
			target_collision.global_position.x - rect_size.x / 2,
			target_collision.global_position.y - rect_size.y - 3
		)
	else:
		print("Collision shape not supported: create_new_hit")
	global_position = target_head
	print(global_position)
		

func _process(delta):
	lifetime -= delta
	global_position.y = global_position.y - (FLOAT_PIXEL_AMOUNT * delta)
	
	# Grow big then grow small
	if lifetime < grow_small_after:
		scale = scale + Vector2(-1, -1) * delta
	else:
		scale = scale + Vector2(2, 2) * delta
		
	if lifetime < 0:
		queue_free()
	

static func create_new_hit(collision_shape: CollisionShape2D, damage: int) -> Label:
	var hit_scene = load("res://scenes/effect_scenes/enemy_hit.tscn")
	var hit_label: Hit = hit_scene.instantiate()
	hit_label.text = str(damage)
	hit_label.target_collision = collision_shape
	return hit_label
	
