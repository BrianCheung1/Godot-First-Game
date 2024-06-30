extends Node2D


@onready var main_menu = $UI/Control/MainMenu
@onready var player = $Player
const BlinkPotion = preload("res://scripts/Consumables/BlinkPotion.gd")

func _ready():
	main_menu.hide()

func _on_timer_timeout():
	var potion = BlinkPotion.new(player, 1)
	player.inventory.add_item(potion)
	pass # Replace with function body.
