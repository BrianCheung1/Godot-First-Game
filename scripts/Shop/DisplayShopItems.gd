extends Control

var logger
var shop_items:Dictionary = AllItems.shop_items
var shop
@onready var shop_tree = $"."
@onready var inventory = $"../../../RightSide/InventoryScroll/Inventory"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Shop Items Script]")
	shop = DisplayItems.new(shop_items, shop_tree)
	shop.set_items()
	shop.ON_BUY.connect(on_buy)
	player = get_tree().get_first_node_in_group("player")
	print(player.inventory.items)

func on_buy(key):
	inventory.bought_item(key)
	
func sold(key):
	if key not in shop_items:
		shop_items[key] = inventory.inventory_items[key].duplicate()
		shop_items[key]["Quantity"] = 0
		shop.add_item(key)
	shop_items[key]["Quantity"] +=1
	var to_sell_item = Item.new(player, key, 1).determine_item(key).new(player,1)
	player.inventory.remove_used_item(0)
	if key in shop.node_dict:
		var label = shop.node_dict[key][3]
		label.text = "x" + str(shop_items[key]["Quantity"])
	
	
