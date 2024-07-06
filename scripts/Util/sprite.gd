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
	
#static func create_sprite(attack_texture_or_scene, target_size:Vector2, position:Vector2):
	#var new_sprite
	#
	#if attack_texture_or_scene is PackedScene:
		#var scene_instance = attack_texture_or_scene.instantiate()
		#if scene_instance is AnimatedSprite2D:
			#new_sprite = scene_instance
			## Calculate scale factor based on the first frame
			#print(new_sprite.get_sprite_frames())
			#var frame_texture = new_sprite.get_sprite_frames().get_frame_texture("default",0)
			#print(frame_texture)
			#var scale_factor = target_size / frame_texture.get_size()
			#new_sprite.scale = scale_factor
			#new_sprite.position = position
		#elif scene_instance is Sprite2D:
			#new_sprite = scene_instance
			#new_sprite.scale = target_size / new_sprite.texture.get_size()
		#else:
			## Handle other scene types if needed
			#return null
	#else:
		#if attack_texture_or_scene is Texture2D:
			#new_sprite = Sprite2D.new()
			#new_sprite.texture = attack_texture_or_scene
			#new_sprite.scale = target_size / attack_texture_or_scene.get_size()
		#elif attack_texture_or_scene is AnimatedSprite2D:
			#new_sprite = AnimatedSprite2D.new()
			#new_sprite.frames = attack_texture_or_scene.frames
			## Calculate scale factor based on the first frame
			#var frame_texture = new_sprite.frames.get_frame("default", 0)
			#var scale_factor = target_size / frame_texture.get_size()
			#new_sprite.scale = scale_factor
		#else:
			## Handle other texture types if needed
			#return null
	#
	#new_sprite.position = position - target_size / 2
	#
	#return new_sprite





