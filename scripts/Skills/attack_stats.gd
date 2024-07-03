extends Node


class_name AttackStats

var DAMAGE:int
var SKILL_RANGE:Vector2
var GLOBAL_POSITION:Vector2
var ATTACK_DURATION:float
var SPEED_MULTIPLIER:float
var ATTACK_DIRECTION:String
var ATTACK_SIZE:Vector2

func _init(damage:int, skill_range:Vector2, position:Vector2, duration:float, speed_multiplier:float, attack_direction:String, attack_size:Vector2):
	self.DAMAGE = damage
	self.SKILL_RANGE = skill_range
	self.GLOBAL_POSITION = position
	self.ATTACK_DURATION = duration
	self.SPEED_MULTIPLIER = speed_multiplier
	self.ATTACK_DIRECTION = attack_direction
	self.ATTACK_SIZE = attack_size
