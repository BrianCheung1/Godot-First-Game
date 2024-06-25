extends Control


@export var leaderboardScene:PackedScene
var leaderboard
@onready var margin_container = $MarginContainer

func _on_level_1_button_pressed():
	create_leaderboard("butter-knights-butter-knights-2wUo")
	

func _on_level_2_button_pressed():
	create_leaderboard("butter-knights-level2-ry9g")

func create_leaderboard(leaderboardID):
	margin_container.hide()
	leaderboard = leaderboardScene.instantiate()
	leaderboard.leaderboard_id = leaderboardID
	add_child(leaderboard)
	var button = Button.new()
	leaderboard.add_child(button)
	button.set_text("Close")
	button.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
	# Set anchor to bottom
	button.anchor_left = 0.5
	button.anchor_right = 0.5
	button.anchor_top = 0.75
	button.pressed.connect(_on_button_press)

func _on_button_press():
	leaderboard.queue_free()
	margin_container.show()

func _on_main_menu_button_pressed():
	hide()
