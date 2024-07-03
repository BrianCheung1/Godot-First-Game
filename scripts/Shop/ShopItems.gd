extends Node

var gold = 1000
var items = {
	0:{
		"Name": "Blink",
		"Desc": "Blinks player 50 pixels",
		"Cost": 10,
		"Quantity": 10,
		"Image" :load("res://assets/sprites/2_item.png"),
	},
	1:{
		"Name": "Health",
		"Desc": "Heal Player 10 hp",
		"Cost": 20,
		"Quantity": 5,
		"Image" :load("res://assets/sprites/1_item.png"),
	},
	2:{
		"Name": "SuckCoin",
		"Desc": "Sucks all coins on the mapaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
		"Cost": 30,
		"Quantity": 1,
		"Image" :load("res://assets/sprites/4_item.png"),
	},
}
