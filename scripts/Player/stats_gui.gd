extends Control
class_name Stats

@onready var player_name = $VBoxContainer/PlayerName
@onready var player_health = $PlayerHealth
@onready var player_speed = $PlayerSpeed
@onready var player_jump = $PlayerJump
@onready var player_potions = $PlayerPotions
@onready var player_invinciblity = $PlayerInvinciblity
@onready var player = $"../.."


var max_coins:int
var logger = Logger.new("[Stats Scene]")
var item_count:int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player_name.text = PlayerVariables.player_name
	player_health.text = str(player.hp) + "/" + str(player.MAX_HP) + " HP"
	player_speed.text = str(player.SPEED) + " SPEED"
	player_jump.text = str(abs(player.JUMP_VELOCITY_BASE))+ "/" + str(abs(player.jump_velocity)) + " JUMP"
	player_invinciblity.text = str(player.INVINCIBILITY_TIME) + "SEC INVINCIBLE TIMER"


func update_stats():
	player_name.text = PlayerVariables.player_name
	player_health.text = str(player.hp) + "/" + str(player.MAX_HP) + " HP"
	player_speed.text = str(player.SPEED) + " SPEED"
	player_jump.text = str(abs(player.JUMP_VELOCITY_BASE))+ "/" + str(abs(player.jump_velocity))  + " JUMP"
	player_invinciblity.text = str(player.INVINCIBILITY_TIME) + "SEC INVINCIBLE TIMER"
