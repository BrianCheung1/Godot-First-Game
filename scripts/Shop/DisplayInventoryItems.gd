extends Control

var logger
var inventory_items:Dictionary = AllItems.player_items
var inventory
@onready var inventory_tree = $"."
@onready var shop = $"../../../LeftSide2/ShopScroll/Shop"

# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Invetory Items Script]")
	inventory = DisplayItems.new(inventory_items, inventory_tree)
	inventory.set_items()
	inventory.ON_SELL.connect(on_sell)

func on_sell(key):
	shop.sold(key)
		
func bought_item(key):
	if key not in inventory_items:
		inventory_items[key] = AllItems.shop_items[key].duplicate()
		inventory_items[key]["Quantity"] = 0
		print(inventory_items[key])
		print(AllItems.shop_items[key])
		inventory.add_item(key)
	inventory_items[key]["Quantity"] +=1
	if key in inventory.node_dict:
		var label = inventory.node_dict[key]
		label.text = "x" + str(inventory_items[key]["Quantity"])
