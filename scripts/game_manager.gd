extends Node

var score = 0
var time = 0
var in_game = true
var total_coins = 0
@onready var score_label = $ScoreLabel
@onready var hud = $HUD
@onready var endzone = $Endzone
@onready var ui = $"../UI"

@export var leaderboardScene:PackedScene
@export var leaderboardID: String

signal close_button

var leaderboard

func _ready():
	total_coins = get_tree().get_nodes_in_group("coin").size()
	hud.get_node("ScoreLabel").text = str(score) + "/" + str(total_coins) + " coins"
	
func add_point():
	score +=1
	score_label.text = "You've collected " + str(score) + "/" + str(total_coins) +" coins!"
	hud.get_node("ScoreLabel").text = str(score) + "/" + str(total_coins) + " coins"
	
func end_game():
	if score < total_coins:
		print("didnt win yet")
	else:
		in_game = false
		if leaderboard:
			leaderboard.queue_free()
		leaderboard = leaderboardScene.instantiate()
		leaderboard.leaderboard_id = leaderboardID
		ui.add_child(leaderboard)
		var button = Button.new()
		leaderboard.add_child(button)
		button.set_text("Close")
		button.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
		# Set anchor to bottom
		button.anchor_left = 0.5
		button.anchor_right = 0.5
		button.anchor_top = 0.75
		button.pressed.connect(_on_button_press)
		
	return in_game

func _process(delta):
	if in_game:
		updateTimer(delta)
		PlayerVariables.player_time=time

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

func _on_button_press():
	leaderboard.queue_free()
