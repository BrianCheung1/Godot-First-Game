extends Node
class_name Item

var _player: Player
var _name: String
var _count: int
var _level: Node
var logger = Logger.new("[Item]")

var determineItem = {
	"BlinkPotion" : BlinkPotion,
	"GravityPotion" : GravityPotion,
	"KillAllPotion": KillAllPotion,
	"SuckCoinPotion" : SuckCoinPotion,
	"AuraItem": AuraItem,
	"InvincibilityBuff": InvincibilityBuff,
	"HealthPotion":HealthPotion,
	"JumpPotion":JumpPotion,
}

func determine_item(item_name:String):
	return determineItem[item_name]

func _init(player: Player, name, count):
	if(player):
		self._player = player
		self._level = player.level
		self._name = name
		self._count = count
	
# Subclasses must override this
func activate():
	print("Not implemented: Used %s" % _name)
	
func _to_string():
	return ("Item [Name=%s Count=%d]" % [_name, _count])

func update_quantity(count:int):
	self._count += count

func possible_items():
	return determineItem.keys()

var Quantity: int:
	get:
		return _count

var Name: String:
	get:
		return _name

var IsEmpty: bool:
	get:
		return _count <= 0
