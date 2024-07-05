extends Control

var logger
#var inventory_items:Dictionary = AllItems.player_items
var inventory_items:Dictionary
var inventory
@onready var inventory_tree = $"."
@onready var shop = $"../../../LeftSide/ShopScroll/Shop"
@onready var game_manager = %GameManager


# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Invetory Items Script]")
	var player = get_tree().get_first_node_in_group("player")
	for item in player.inventory.items:
		if item != null:
			print(item.Name)
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
	
	
func on_sell(key):
	shop.sold(key)
		
func bought_item(key):
	if key not in inventory_items:
		inventory_items[key] = AllItems.shop_items[key].duplicate()
		inventory_items[key]["Quantity"] = 0
		inventory.add_item(key)
	inventory_items[key]["Quantity"] +=1
	if key in inventory.node_dict:
		var item_quantity_label = inventory.node_dict[key][3]
		item_quantity_label.text = "x" + str(inventory_items[key]["Quantity"])
