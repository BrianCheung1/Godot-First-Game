extends Polygon2D
class_name AttackIndicator

enum Type {
	Fade,
	FadeAppearRepeat
}

enum Orientation {
	Vertical,
	Horizontal
}

const BASE_COLOR = Color(0.656, 0.385, 0.353)
const TWEEN_DURATION = 1

var logger = Logger.new("[attack indicator]")

# Should be set by the factory methods
var parent: Node2D
var lifetime: float
var type: Type
var to_rotate: float

# For indicator on top of collision 2d
var hitbox: CollisionShape2D

# For indicator that starts from `startpos` and end at `endpos` with a width of `width`
var startpos: Vector2
var endpos: Vector2
var width: int
var orientation: Orientation

# Should not be called directly, create new instances using the static factory methods
func _init():
	pass
	
func go():
	# Set Polygon2D property
	color = BASE_COLOR
	z_as_relative = false
	z_index = -400
	
	# Set the position based on whether we have vertices or a collision hitbox
	if hitbox:
		var shape = hitbox.shape
		var size = Util.try_get_rectangle_size(hitbox)
		if size == null:
			logger.print("failed to get size of shape")
			queue_free()
			return
		var width = size.x
		var height = size.y
		
		# Position and vector calculation?
		position = hitbox.position
		polygon = PackedVector2Array([
			Vector2(-width/2, height/2),
			Vector2(-width/2, -height/2),
			Vector2(width/2, -height/2),
			Vector2(width/2, height/2)
		])
		rotation = hitbox.rotation
		hitbox.get_parent().add_child(self)
		
	else:
		global_position = parent.global_position
		if orientation == Orientation.Vertical:
			polygon = PackedVector2Array([
				Vector2(startpos.x - width/2, startpos.y),
				Vector2(startpos.x + width/2, startpos.y),
				Vector2(endpos.x + width/2, endpos.y),
				Vector2(endpos.x - width/2, endpos.y)
			])
		else:
			polygon = PackedVector2Array([
				Vector2(startpos.x, startpos.y + width/2),
				Vector2(startpos.x, startpos.y - width/2),
				Vector2(endpos.x, endpos.y - width/2),
				Vector2(endpos.x, endpos.y + width/2)
			])
		#logger.print(polygon)
		#logger.print(global_position)
		#logger.print(parent.global_position)
		parent.add_child(self)
	
	# Start tween
	if type == Type.FadeAppearRepeat:
		create_fade_tween()
	elif type == Type.Fade:
		create_fade_to_0()
	
func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func create_fade_to_0():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), lifetime)
	tween.play()
	
func create_fade_tween():
	var tween = create_tween()
	tween.finished.connect(create_appear_tween)
	tween.tween_property(self, "modulate", Color(1,1,1,0.3), TWEEN_DURATION)
	tween.play()
	
func create_appear_tween():
	var tween = create_tween()
	tween.finished.connect(create_fade_tween)
	tween.tween_property(self, "modulate", Color(1,1,1,0.7), TWEEN_DURATION)
	tween.play()
	
#static func create_from_collisionshape2d_with_rotation(parent: Node2D, lifetime: float, hitbox: CollisionShape2D, rotate_by: float = 0, type: Type = Type.FadeAppearRepeat) -> AttackIndicator:
	#var node = create_from_collisionshape2d(parent, lifetime, hitbox, type)
	#node.to_rotate = rotate_by
	#return node
	
static func create_from_collisionshape2d(parent: Node2D, lifetime: float, hitbox: CollisionShape2D, type: Type = Type.FadeAppearRepeat) -> AttackIndicator:
	var node = AttackIndicator.new()
	node.lifetime = lifetime
	node.hitbox = hitbox
	node.parent = parent
	node.type = type
	return node
	
static func create_from_positions(parent: Node2D, lifetime: float, startpos: Vector2, endpos: Vector2, width: int, orientation: AttackIndicator.Orientation, type: Type = Type.FadeAppearRepeat) -> AttackIndicator:
	var node = AttackIndicator.new()
	node.lifetime = lifetime
	node.startpos = startpos
	node.endpos = endpos
	node.width = width
	node.parent = parent
	node.type = type
	node.orientation = orientation
	return node
