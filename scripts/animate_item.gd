extends Sprite2D

# Properties for floating animation
var original_position: Vector2
var current_offset: int = 0
var max_offset: int = 2
var update_frequency: int = 10
var frame_counter: int = 0
var direction: int = 1  # 1 for upward movement, -1 for downward movement

func _ready():
	self.scale = Vector2(.03,.03)
	original_position = position  # Store the original position

func _process(delta):
	frame_counter += 1
	
	# Update the position every update_frequency frames
	if frame_counter % update_frequency == 0:
		current_offset += direction
		
		# Update the position of the sprite
		position = original_position + Vector2(0, current_offset)
		
		# Check if we need to change direction
		if current_offset >= max_offset:
			direction = -1
		elif current_offset <= -max_offset:
			direction = 1
