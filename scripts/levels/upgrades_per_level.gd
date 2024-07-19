extends CanvasLayer
@onready var buff_1_texture = $Background/BoxContainer/LeftContainer/VBoxContainer/Buff1Texture
@onready var buff_2_texture = $Background/BoxContainer/MiddleContainer/VBoxContainer/Buff2Texture
@onready var buff_3_texture = $Background/BoxContainer/RightContainer/VBoxContainer/Buff3Texture
@onready var buff_1_button = $Background/BoxContainer/LeftContainer/VBoxContainer/Buff1Button
@onready var buff_2_button = $Background/BoxContainer/MiddleContainer/VBoxContainer/Buff2Button
@onready var buff_3_button = $Background/BoxContainer/RightContainer/VBoxContainer/Buff3Button

var buffs = ["attack_damage", "max_health", "speed", "jump"]
var buff_1_pressed
var buff_2_pressed
var buff_3_pressed
@onready var textures = [buff_1_texture, buff_2_texture, buff_3_texture]
@onready var buttons = [buff_1_button, buff_2_button, buff_3_button]

func _ready():
	buff_1_pressed = get_random_buff(0)
	buff_2_pressed = get_random_buff(1)
	buff_3_pressed = get_random_buff(2)

func _on_buff_1_button_pressed():
	hide()
	change_stats(buff_1_pressed)
	
func _on_buff_2_button_pressed():
	hide()
	change_stats(buff_2_pressed)

func _on_buff_3_button_pressed():
	hide()
	change_stats(buff_3_pressed)


func get_random_buff(index):
	var buff = buffs.pick_random()
	buffs.erase(buff)
	if buff == "attack_damage":
		textures[index].texture = load("res://assets/sprites/5_item.png")
		buttons[index].text = "Attack +15"
		return buff
	elif buff == "max_health":
		textures[index].texture = load("res://assets/sprites/6_item.png")
		buttons[index].text = "Health +20"
		return buff
	elif buff == "speed":
		textures[index].texture = load("res://assets/sprites/8_item.png")
		buttons[index].text = "Speed +20"
		return buff
	elif buff == "jump":
		textures[index].texture = load("res://assets/sprites/9_item.png")
		buttons[index].text = "Jump +10"
		return buff

func change_stats(buff):
	if buff == "attack_damage":
		PlayerVariables.player_attack_damage += 15
	elif buff == "max_health":
		PlayerVariables.player_MAX_HP += 20
	elif buff == "speed":
		PlayerVariables.player_speed += 20
	elif buff == "jump":
		PlayerVariables.player_jump_velocity -= 10
	change_level()
	
func change_level():
	var level = str(get_tree().current_scene.name)
	var res = int(level[-1]) + 1
	print(res)
	var change_to_level = "level_" + str(res) + ".tscn"
	get_tree().change_scene_to_file("res://scenes/levels/%s" % change_to_level)
