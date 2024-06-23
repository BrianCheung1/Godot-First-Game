extends Node

var score = 0
var time = 0
var in_game = true
@onready var score_label = $ScoreLabel
@onready var hud = $HUD
@onready var endzone = $Endzone

func add_point():
	score +=1
	score_label.text = "You've collected " + str(score) + "/27 coins!"
	hud.get_node("ScoreLabel").text = str(score) + "/27 coins"
	
func end_game():
	if score < 27:
		print("didnt win yet")
	else:
		in_game = false
	return in_game

func _process(delta):
	if in_game:
		updateTimer(delta)

func updateTimer(delta):
	time += delta
	hud.get_node("TimerLabel").text = format_time(time)

func format_time(time):
	var hours = int(int(time) / 3600)
	var minutes = int((int(time) % 3600) / 60)
	var seconds = int(int(time) % 60)
	var milliseconds = int((time - int(time)) * 1000)
	
	return str(hours).pad_zeros(2) + ":" + \
		   str(minutes).pad_zeros(2) + ":" + \
		   str(seconds).pad_zeros(2) + ":" + \
		   str(milliseconds).pad_zeros(3)
