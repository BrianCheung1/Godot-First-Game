extends Node

var save_path = "user://player_variables.dat"
var player_name:String = load_name()
var player_time:float = 999999999999999999
var player_deaths:int = 0
var player_resets:int = 0
var player_ip = load_ip()

func save_name():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_name)
	file.store_var(player_ip)
	
func load_name():
	print(save_path)
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		player_name = file.get_var()
	else:
		print("file not found")
		player_name = "Guest"
	return player_name

func load_ip():
	print(save_path)
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		player_name = file.get_var()
		player_ip = file.get_var()
	else:
		print("file not found")
		player_name = "127.0.0.1"
	return player_ip
