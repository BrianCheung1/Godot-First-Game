extends Node

class_name Sprite

static func create_sprite(attackTexture:Texture, target_size:Vector2, position:Vector2):
	var new_sprite = Sprite2D.new()
	new_sprite.texture = attackTexture
	new_sprite.scale = target_size/attackTexture.get_size()
	new_sprite.position = Vector2(target_size.x/2 - (target_size.x/2), position.y - (target_size.y/2)) 
	
	return new_sprite
