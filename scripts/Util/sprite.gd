extends Node

class_name Sprite

static func create_sprite(attackTexture:Texture, target_size:Vector2, position:Vector2):
	var new_sprite = Sprite2D.new()
	new_sprite.texture = attackTexture
	new_sprite.scale = target_size/attackTexture.get_size()
	new_sprite.position = Vector2(target_size.x/2 - (target_size.x/2), position.y - (target_size.y/2)) 
	
	return new_sprite
 
static func resize_packed_scene(attackTexture:PackedScene, target_size:Vector2, position:Vector2):
	var scene_instance = attackTexture.instantiate()
	if scene_instance is AnimatedSprite2D:
		var frame_texture = scene_instance.get_sprite_frames().get_frame_texture("default",0)
			
		var scale_factor = target_size / frame_texture.get_size()
		scene_instance.scale = scale_factor
		scene_instance.position = Vector2(target_size.x/2 - (target_size.x/2), position.y - (target_size.y/2))
	
	return scene_instance
	
static func get_current_sprite_size(animated_sprite: AnimatedSprite2D, animation_name:String) -> Vector2:
	if animated_sprite:
		# Get the SpriteFrames resource
		var sprite_frames = animated_sprite.sprite_frames
		
		if sprite_frames:
			# Get the texture for the first frame of the specified animation
			var texture = sprite_frames.get_frame_texture(animation_name, 0)
			
			if texture:
				# Return the size of the texture
				return texture.get_size()
	
	# Return a default size if something goes wrong
	return Vector2(0, 0)
