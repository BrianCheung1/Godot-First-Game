extends Sprite2D

var max_offset: int = 3

func _ready():
	self.scale = Vector2(.03,.03)
	tween_down()

func tween_up():	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "position", Vector2(position.x, position.y - max_offset), 0.5)
	await tween.finished
	tween_down()
	
func tween_down():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(position.x, position.y + max_offset), 0.65)
	await tween.finished
	tween_up()
