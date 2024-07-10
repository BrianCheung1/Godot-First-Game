extends Node

var time = 0
var in_game = true
var timer_started = false
@onready var hud = $HUD
@onready var endzone = $Endzone
@onready var ui = $"../UI"
@onready var player = $"../Player"
@onready var coin_label = $HUD/CoinLabel
@onready var upgrades_per_level = $UpgradesPerLevel

@export var leaderboardScene:PackedScene
@export var leaderboardID: String

signal close_button

var leaderboard

func _ready():
	if OS.has_feature("dedicated_server"):
		print("starting dedicated server")
		MultiplayerManager.become_host()
	
	
func add_coins():
	PlayerVariables.player_coins += 1
	coin_label.text = "Coins: " + str(PlayerVariables.player_coins)

func add_coins_on_monster_kill(coins):
	PlayerVariables.player_coins += coins
	coin_label.text = "Coins: " + str(PlayerVariables.player_coins)

func end_game():
	upgrades_per_level.visible = true
	

func _process(delta):
	hud.get_node("DeathLabel").text = "Deaths: " + str(PlayerVariables.player_deaths)
	hud.get_node("ResetLabel").text = "Resets: " + str(PlayerVariables.player_resets)
	hud.get_node("PlayerLabel").text = PlayerVariables.player_name + " [HP {hp}/{max_hp}]".format({ "hp": player.hp, "max_hp": player.MAX_HP })
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_left") or Input.is_action_pressed("jump"):
		timer_started = true
	if in_game and timer_started:
		updateTimer(delta)

func updateTimer(delta):
	time += delta
	PlayerVariables.player_time=time
	hud.get_node("TimerLabel").text = format_time(time)
	PlayerVariables.player_time=time

func format_time(time):
	var hours = int(int(time) / 3600)
	var minutes = int((int(time) % 3600) / 60)
	var seconds = int(int(time) % 60)
	var milliseconds = int((time - int(time)) * 1000)
	
	return str(hours).pad_zeros(2) + ":" + \
		   str(minutes).pad_zeros(2) + ":" + \
		   str(seconds).pad_zeros(2) + ":" + \
		   str(milliseconds).pad_zeros(3)

func _on_button_press():
	leaderboard.queue_free()

func become_host():
	print("Become Host Pressed")
	%MultiplayerHUD.hide()
	MultiplayerManager.become_host()
	hud.get_node("PlayerLabel").text = "Name/ID: " + PlayerVariables.player_name + "/" + str(multiplayer.get_unique_id())
	
func join_as_player_2():
	MultiplayerManager.join_as_player_2()
	%MultiplayerHUD.hide()
	hud.get_node("PlayerLabel").text = "Name/ID: " + PlayerVariables.player_name + "/" + str(multiplayer.get_unique_id())

func _on_multiplayer_hud_single_player():
	print("Single Player Mode")
	%MultiplayerHUD.hide()


func _on_upgrades_per_level_buff_1():
	change_level()

func _on_upgrades_per_level_buff_2():
	change_level()

func _on_upgrades_per_level_buff_3():
	change_level()

func change_level():
	var level = str(get_tree().current_scene.name)
	var res = int(level[-1]) + 1
	var change_to_level = "level_" + str(res) + ".tscn"
	get_tree().change_scene_to_file("res://scenes/levels/%s" % change_to_level)
	
