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
