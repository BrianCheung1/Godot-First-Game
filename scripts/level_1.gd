extends Level


@onready var main_menu = $UI/Control/MainMenu
@onready var player = $Player
const BlinkPotion = preload("res://scripts/Consumables/BlinkPotion.gd")

func _ready():
	main_menu.hide()


func _on_upgrades_per_level_buff_3():
	pass # Replace with function body.
