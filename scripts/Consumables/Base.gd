class_name Item

var player: Player
var name: String
var count: int

func _init(player, name, count):
	self.player = player
	self.name = name
	self.count = count
	
# Subclasses must override this
func activate():
	print("Not implemented: Used %s" % name)
	
func _to_string():
	return ("Item [Name=%s Count=%d]" % [name, count])
