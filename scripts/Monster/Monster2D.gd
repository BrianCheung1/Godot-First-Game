extends Node2D
class_name Monster2D

const enemy_death_effect = preload("res://scenes/effect_scenes/explosion_4.tscn")

func _init():
	pass
	
func die():
	self.queue_free()
	var node = enemy_death_effect.instantiate()
	get_parent().add_child(node)
	node.global_position = self.global_position
	
func _to_string():
	return ("Monster")
