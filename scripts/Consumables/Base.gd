extends Node
class_name Item

var _player: Player
var _name: String
var _count: int
var _level: Node

func _init(player: Player, name, count):
	self._player = player
	self._level = player.level
	self._name = name
	self._count = count
	
# Subclasses must override this
func activate():
	print("Not implemented: Used %s" % _name)
	
func _to_string():
	return ("Item [Name=%s Count=%d]" % [_name, _count])

var Quantity: int:
	get:
		return _count

var Name: String:
	get:
		return _name

var IsEmpty: bool:
	get:
		return _count == 0
