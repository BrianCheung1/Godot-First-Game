extends Node
class_name Util


# Didn't work for what I wanted to do...
static func get_animatedsprite2d_size(obj: AnimatedSprite2D, apply_scale=true):
	if apply_scale:
		return obj.sprite_frames.get_frame_texture(obj.animation, obj.frame).get_size() * obj.global_scale
	return obj.sprite_frames.get_frame_texture(obj.animation, obj.frame).get_size()
	
