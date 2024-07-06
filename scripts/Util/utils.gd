extends Node
class_name Util


# Didn't work for what I wanted to do...
static func get_animatedsprite2d_size(obj: AnimatedSprite2D, apply_scale=true):
	if apply_scale:
		return obj.sprite_frames.get_frame_texture(obj.animation, obj.frame).get_size() * obj.global_scale
	return obj.sprite_frames.get_frame_texture(obj.animation, obj.frame).get_size()
	
static func try_get_rectangle_size(collision_shape: CollisionShape2D):
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var rect_shape = shape as RectangleShape2D
		return rect_shape.size
	return null

static func get_root(node: Node):
	while node.get_parent() != null:
		node = node.get_parent()
	return node

static func add_node(current: Node, node: Node):
	current.get_parent().add_child(node)
	
static func spawn_and_add_node(current: Node, resource: Resource):
	var node = resource.instantiate()
	add_node(current, node)
	return node

static func traverse_up_until_level(current: Node):
	while not current is Level and current != null:
		current = current.get_parent()
	return current
	
static func is_facing_right(body):
	var is_facing_right
	if(body is Player):
		is_facing_right = body.is_facing_right
	else:
		is_facing_right= (body.direction== -1)
	
	return is_facing_right

static func direction(body): #will need to modify for up and down
	var player_direction = "Neutral"
	
	if(is_facing_right(body)):
		player_direction = "Right"
	else:
		player_direction = "Left"
		
	return player_direction

static func get_character_body_size(character_body: CharacterBody2D) -> Vector2:
	var collision_shape = find_collision_shape(character_body)
	if collision_shape:
		var shape = collision_shape.shape
		if shape is RectangleShape2D:
			return shape.extents * 2  # RectangleShape2D extents are half-sizes
		elif shape is CircleShape2D:
			return Vector2(shape.radius * 2, shape.radius * 2)
		elif shape is CapsuleShape2D:
			return Vector2(shape.radius * 2, shape.height + shape.radius * 2)
		# Add other shape types if needed
	return Vector2.ZERO

static func find_collision_shape(node: Node) -> CollisionShape2D:
	for child in node.get_children():
		if child is CollisionShape2D:
			return child
	return null

static func find_target(body):
	var target = null
	if(body is Monster2D or body is SlimeBoss):
		target = body.get_tree().get_first_node_in_group("player")
	if(body is Player):
		target = body.get_tree().get_first_node_in_group("boss")
		
	return target
