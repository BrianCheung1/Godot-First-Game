extends Polygon2D
class_name AttackIndicator

const BASE_COLOR = Color(0.826, 0.195, 0.263)
const TWEEN_DURATION = 1

var logger = Logger.new("[attack indicator]")

# Should be set by the factory methods
var parent: Node2D
var lifetime: float
var hitbox: CollisionShape2D
var type: String

# Should not be called, create new instances using the static factory methods
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
		
		# Position and vector calculation weird IDK...
		position = hitbox.position
		position.x -= width / 2
		position.y -= height / 2
		polygon = PackedVector2Array([
			Vector2(0, 0),
			Vector2(width, 0),
			Vector2(width, height),
			Vector2(0, height)
		])
		hitbox.get_parent().add_child(self)
	else:
		# TODO: for now just set to parent position and create a 0
		position = Vector2(0, 0)
		polygon = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100), Vector2(0, 100)])
		
	
	# Start tween
	if type == "fadeappear":
		create_fade_tween()
	elif type == "fade":
		create_fade_to_0()
	
func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()

func create_fade_to_0():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0.3), lifetime)
	tween.play()
	
func create_fade_tween():
	var tween = create_tween()
	tween.finished.connect(create_appear_tween)
	tween.tween_property(self, "modulate", Color(1,1,1,0.3), TWEEN_DURATION)
	tween.play()
	
func create_appear_tween():
	var tween = create_tween()
	tween.finished.connect(create_fade_tween)
	tween.tween_property(self, "modulate", Color(1,1,1,1), TWEEN_DURATION)
	tween.play()
	
static func create_from_collisionshape2d(parent: Node2D, lifetime: float, hitbox: CollisionShape2D, type: String = "fadeappear") -> AttackIndicator:
	var node = AttackIndicator.new()
	node.lifetime = lifetime
	node.hitbox = hitbox
	node.parent = parent
	node.type = type
	return node
	
