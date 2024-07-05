extends Control

var logger
var shop_items:Dictionary = AllItems.shop_items
var shop
@onready var shop_tree = $"."
@onready var inventory = $"../../../RightSide/InventoryScroll/Inventory"
var player
@onready var coins = $"../../../RightSide/Coins"


# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Shop Items Script]")
	shop = DisplayItems.new(shop_items, shop_tree)
	shop.set_items()
	shop.ON_BUY.connect(on_buy)
	player = get_tree().get_first_node_in_group("player")

func on_buy(key):
	inventory.bought_item(key)
	
func sold(key):
	if key not in shop_items:
		shop_items[key] = inventory.inventory_items[key].duplicate()
		shop_items[key]["Quantity"] = 0
		shop.add_item(key)
	shop_items[key]["Quantity"] +=1
	PlayerVariables.player_coins += inventory.inventory_items[key]["Cost"]
	coins.text = "Coins: $" + str(PlayerVariables.player_coins)
	var to_sell_item_index = 0
	for item in player.inventory.items:
		if item == null:
			to_sell_item_index+=1
			continue
		if item.Name == key:
			break
		to_sell_item_index+=1
	logger.print(player.inventory.items)
	logger.print(to_sell_item_index)
	player.inventory.items[to_sell_item_index].update_quantity(-1)
	player.inventory.remove_used_item(to_sell_item_index)
	if key in shop.node_dict:
		var label = shop.node_dict[key][3]
		label.text = "x" + str(shop_items[key]["Quantity"])
	
	
