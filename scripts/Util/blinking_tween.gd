extends ColorRect

class_name BlinkingIndicator

var body
var tween
var blink_duration
var color_rect
var duration
var timer_duration
var BLINK_DURATION


func _init(color_rect_size: Vector2, position: Vector2, duration: float, body):
	self.body = body
	BLINK_DURATION = min(.25, duration/2)
	color_rect = ColorRect.new()
	color_rect.size = color_rect_size
	color_rect.color = Color(1,0,0,0.2)  # Set the color (red in this case)
	color_rect.position = position
	color_rect.top_level = true
	blink_duration = BLINK_DURATION
	self.duration = duration
	timer_duration = duration
	add_child(color_rect)

	
	# Create the Tween node
	tween = body.get_tree().create_tween()
	start_blinking()

func _process(delta):
	timer_duration -= delta
	blink_duration -= delta
	if(timer_duration <= 0):
		end_blink()
	
	if(blink_duration <= 0):
		blink_duration = BLINK_DURATION
		color_rect.visible = !color_rect.visible
	

func start_blinking() -> void:
	# Fade out over half of blink_duration seconds
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	tween.play()

func end_blink():
	queue_free()
	tween.stop()
	tween.tween_callback(queue_free)
