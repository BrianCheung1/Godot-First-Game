extends CanvasLayer
@onready var buff_1_texture = $Background/BoxContainer/LeftContainer/VBoxContainer/Buff1Texture
@onready var buff_2_texture = $Background/BoxContainer/MiddleContainer/VBoxContainer/Buff2Texture
@onready var buff_3_texture = $Background/BoxContainer/RightContainer/VBoxContainer/Buff3Texture
@onready var buff_1_button = $Background/BoxContainer/LeftContainer/VBoxContainer/Buff1Button
@onready var buff_2_button = $Background/BoxContainer/MiddleContainer/VBoxContainer/Buff2Button
@onready var buff_3_button = $Background/BoxContainer/RightContainer/VBoxContainer/Buff3Button

var buffs = ["attack_damage", "max_health", "speed", "jump"]
@onready var textures = [buff_1_texture, buff_2_texture, buff_3_texture]
@onready var buttons = [buff_1_button, buff_2_button, buff_3_button]
signal buff_1()
signal buff_2()
signal buff_3()

func _ready():
	get_random_buff(0)
	get_random_buff(1)
	get_random_buff(2)

func _on_buff_1_button_pressed():
	buff_1.emit()
	hide()


func _on_buff_2_button_pressed():
	buff_2.emit()
	hide()

func _on_buff_3_button_pressed():
	buff_3.emit()
	hide()


func get_random_buff(index):
	var buff = buffs.pick_random()
	buffs.erase(buff)
	if buff == "attack_damage":
		PlayerVariables.player_attack_damage += 50
		textures[index].texture = load("res://assets/sprites/5_item.png")
		buttons[index].text = "Attack +50"
	elif buff == "max_health":
		PlayerVariables.player_MAX_HP += 50
		textures[index].texture = load("res://assets/sprites/6_item.png")
		buttons[index].text = "Health +50"
	elif buff == "speed":
		PlayerVariables.player_speed += 50
		textures[index].texture = load("res://assets/sprites/8_item.png")
		buttons[index].text = "Speed +50"
	elif buff == "jump":
		PlayerVariables.player_jump_velocity +=50
		textures[index].texture = load("res://assets/sprites/9_item.png")
		buttons[index].text = "Jump +50"
		
