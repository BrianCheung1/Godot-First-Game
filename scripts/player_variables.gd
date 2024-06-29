extends Node

var save_path = "user://player_variables.dat"
var player_name:String
var player_time:float = 999999999999999999
var player_deaths:int = 0
var player_resets:int = 0
var player_ip

func _ready():
	player_name = load_name()
	player_ip = load_ip()
	
func save_name():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_name)
	file.store_var(player_ip)
	
func load_name():
	if not FileAccess.file_exists(save_path):
		return "Guest"
	var file = FileAccess.open(save_path, FileAccess.READ)
	return file.get_var()

func load_ip():
	print(save_path)
	if not FileAccess.file_exists(save_path):
		return "127.0.0.1"
	var file = FileAccess.open(save_path, FileAccess.READ)
	return file.get_var()
