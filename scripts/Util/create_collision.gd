extends Node

class_name Collision
	
static func create_rectangle(shape_size:Vector2, position:Vector2):
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(shape_size.x/2, shape_size.y/2)
	collision_shape.shape = shape
	collision_shape.position = Vector2(shape_size.x/2 - (shape_size.x/2),position.y + shape_size.y/2  - shape_size.y)
	
	return collision_shape
