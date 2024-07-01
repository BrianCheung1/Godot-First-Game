extends Node
class_name Item

var _player: Player
var _name: String
var _count: int
var _level: Node
var textureSource: String
const itemSpriteSource = {
	"Blink Potion" : "res://assets/sprites/1_item.png",
	"Gravity Potion" : "res://assets/sprites/2_item.png",
	"Kill All Potion" : "res://assets/sprites/3_item.png",
	"Suck Coin Potion" : "res://assets/sprites/4_item.png",
	"Aura Item" : "res://assets/sprites/5_item.png",
	"Invincibility Buff": "res://assets/sprites/6_item.png",
	"Health Potion" : "res://assets/sprites/7_item.png"
}

func _init(player: Player, name, count):
	self._player = player
	self._level = player.level
	self._name = name
	self._count = count
	self.textureSource = itemSpriteSource[name]
	
# Subclasses must override this
func activate():
	print("Not implemented: Used %s" % _name)
	
func _to_string():
	return ("Item [Name=%s Count=%d]" % [_name, _count])

func update_quantity(count:int):
	self._count += count

var Quantity: int:
	get:
		return _count

var Name: String:
	get:
		return _name

var IsEmpty: bool:
	get:
		return _count <= 0
