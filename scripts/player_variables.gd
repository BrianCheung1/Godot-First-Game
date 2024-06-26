extends Node

var save_path = "user://player_variables.dat"
var player_name:String = load_name()
var player_time:int = 999999999999999999
var player_deaths:int = 0
var player_resets:int = 0

func save_name():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_name)
	
func load_name():
	print(save_path)
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		player_name = file.get_var()
	else:
		print("file not found")
		player_name = "Guest"
	return player_name
