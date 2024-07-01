extends Node2D


@onready var main_menu = $UI/Control/MainMenu
@onready var player = $Player
const BlinkPotion = preload("res://scripts/Consumables/BlinkPotion.gd")

func _ready():
	main_menu.hide()
