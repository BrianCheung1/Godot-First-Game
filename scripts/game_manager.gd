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

func _process(delta):
	if in_game:
		updateTimer(delta)

func updateTimer(delta):
	time += delta
	hud.get_node("TimerLabel").text = String.num(time, 2)

func _on_endzone_body_entered(body):
	print("You Win")
	endzone.get_node("CollisionShape2D").queue_free()
	in_game = false
