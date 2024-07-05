extends Node
class_name Item

var _player: Player 
var _name: String
var _count: int
var _level: Node
var logger = Logger.new("[Item]")
var _desc: String 
var _cost: int
var _image


var determineItem = {
	"BlinkPotion" : BlinkPotion,
	"GravityPotion" : GravityPotion,
	"KillAllPotion": KillAllPotion,
	"SuckCoinPotion" : SuckCoinPotion,
	"AuraItem": AuraItem,
	"InvincibilityBuff": InvincibilityBuff,
	"HealthPotion":HealthPotion,
	"JumpPotion":JumpPotion,
	"AvengerItem":AvengerItem,
	"ExplosionItem" : ExplosionItem
}

func determine_item(item_name:String):
	return determineItem[item_name]

func _init(player: Player, name, count, desc="N/A", cost = 0, image=load("res://assets/sprites/1_item.png")):
	if(player):
		self._player = player
		self._level = player.level
		self._name = name
		self._count = count
		self._cost = cost
		self._desc = desc
		self._image = image
	
# Subclasses must override this
func activate():
	print("Not implemented: Used %s" % _name)
	
func _to_string():
	return ("Item [Name=%s Desc=%s Count=%d Cost=%d Image=%s]" % [_name,_desc, _count, _cost, _image])

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
		
var Desc: String:
	get:
		return _desc

var Cost:int:
	get:
		return _cost
		
var Texture_Image:
	get:
		return _image

var IsEmpty: bool:
	get:
		return _count <= 0
