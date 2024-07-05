extends Control

var logger
#var inventory_items:Dictionary = AllItems.player_items
var inventory_items:Dictionary
var inventory
@onready var inventory_tree = $"."
@onready var shop = $"../../../LeftSide/ShopScroll/Shop"
@onready var game_manager = %GameManager
var player
@onready var coins = $"../../Coins"



# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Invetory Items Script]")
	player = get_tree().get_first_node_in_group("player")
	for item in player.inventory.items:
		if item != null:
			inventory_items[item.Name] = {
				"Name": item.Name,
				"Desc": item.Desc,
				"Cost": item.Cost,
				"Quantity": item.Quantity,
				"Image": item.Texture_Image
			}
	inventory = DisplayItems.new(inventory_items, inventory_tree)
	inventory.set_items()
	inventory.ON_SELL.connect(on_sell)
	coins.text = "Coins: $" + str(PlayerVariables.player_coins)
	
	
func on_sell(key):
	shop.sold(key)
		
func bought_item(key):
	if key not in inventory_items:
		inventory_items[key] = AllItems.shop_items[key].duplicate()
		inventory_items[key]["Quantity"] = 0
		inventory.add_item(key)
	inventory_items[key]["Quantity"] +=1
	var to_add_item = Item.new(player, key, 1).determine_item(key).new(player,1)
	PlayerVariables.player_coins -= AllItems.shop_items[key]["Cost"]
	if PlayerVariables.player_coins <= 0:
		PlayerVariables.player_coins = 0
	coins.text = "Coins: $" + str(PlayerVariables.player_coins)
	player.inventory.add_item(to_add_item)
	if key in inventory.node_dict:
		var item_quantity_label = inventory.node_dict[key][3]
		item_quantity_label.text = "x" + str(inventory_items[key]["Quantity"])
