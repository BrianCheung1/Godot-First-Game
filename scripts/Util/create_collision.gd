extends Node

class_name Collision
	
static func create_rectangle(shape_size:Vector2, position:Vector2):
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(shape_size.x/2, shape_size.y/2)
	collision_shape.shape = shape
	collision_shape.position = Vector2(shape_size.x/2 - (shape_size.x/2),position.y + shape_size.y/2  - shape_size.y)
	
	return collision_shape

static func get_collision_shape_size(collision_shape: CollisionShape2D) -> Vector2:
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		return (shape as RectangleShape2D).extents * 2
	elif shape is CircleShape2D:
		var diameter = (shape as CircleShape2D).radius * 2
		return Vector2(diameter, diameter)
	# Add other shape types as needed
	return Vector2.ZERO

static func increase_shape_left_right(collision_shape: CollisionShape2D, left: float, right: float):
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var rect_shape = shape as RectangleShape2D
		var new_extents = rect_shape.extents
		var current_position = collision_shape.position
		
		# Increase extents
		new_extents.x += left + right
		
		# Adjust position to move the shape to the left
		current_position.x -= left
		
		# Apply new extents and position
		rect_shape.extents = new_extents
		collision_shape.position = current_position
	else:
		print("Shape type not supported for this operation")

static func create_new_shape_with_modified_extents(collision_shape: CollisionShape2D, x: float, y: float) -> CollisionShape2D:
	var new_collision_shape = CollisionShape2D.new()
	
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var rect_shape = shape as RectangleShape2D
		var new_rect_shape = RectangleShape2D.new()
		
		var new_extents = rect_shape.extents
		var original_position = collision_shape.position
		var new_position = original_position

		# Increase extents
		new_extents.x += x
		new_extents.y += y

		# Apply new extents and position
		new_rect_shape.extents = new_extents
		new_collision_shape.shape = new_rect_shape
		new_collision_shape.position = new_position

		return new_collision_shape
	else:
		print("Shape type not supported for this operation")
		return null
