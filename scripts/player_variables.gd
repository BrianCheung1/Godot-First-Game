extends Node

var save_path = "user://player_variables.dat"
var player_name:String = "Guest"
var player_time:float = 999999999999999999
var player_deaths:int = 0
var player_resets:int = 0
var player_ip = "127.0.0.1"
var player_coins:int = 0

func _ready():
	load_file()
	save_file()
	
func save_file():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_name)
	file.store_var(player_ip)
	
func load_file():
	if not FileAccess.file_exists(save_path):
		player_name = "Guest"
		player_ip = "127.0.0.1"
		return false
	var file = FileAccess.open(save_path, FileAccess.READ)
	player_name = str(file.get_var())
	player_ip = str(file.get_var())
	return true
