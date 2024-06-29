extends Node

class_name Inventory

@export var items:Array[Item] = []

#@onready var scene = preload("res://scenes/InventoryGUI.tscn")
@onready var inventorySlots:Array[Sprite2D] = [$NinePatchRect/GridContainer/Slot/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot2/VBoxContainer/Sprite2D,  $NinePatchRect/GridContainer/Slot3/VBoxContainer/Sprite2D,  $NinePatchRect/GridContainer/Slot4/VBoxContainer/Sprite2D,  $NinePatchRect/GridContainer/Slot5/VBoxContainer/Sprite2D,
											 $NinePatchRect/GridContainer/Slot6/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot7/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot8/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot9/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot10/VBoxContainer/Sprite2D,
											 $NinePatchRect/GridContainer/Slot11/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot12/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot13/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot14/VBoxContainer/Sprite2D, $NinePatchRect/GridContainer/Slot15/VBoxContainer/Sprite2D]
const MAX_SLOT = 15

func _condense_item(item: Item) -> bool:
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].Name == item.Name:
			self.items[i].Quantity += item.Quantity
			return true
	return false

func attach_sprite(item:Item, index:int):
	var texture = load(item.textureSource)
	print(texture)
	if texture:
		print("inside texture %d %s", index, item.textureSource)
		self.inventorySlots[index].texture = texture
		return
	
	push_error("Error loading texture from item")
	return
	
# Add item to inventory
func add_item(item: Item):
	var condensed = _condense_item(item)
	if(condensed):
		print_items()
		return
		
	if self.items.size() >= MAX_SLOT:
		push_error("Error add item: index >= %d" % MAX_SLOT)
		return
	
	self.items.append(item)
	attach_sprite(item, self.items.size()-1)
	print_items()

func _remove_used_items():
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].IsEmpty:
			self.items[i] = null

func print_items():
	for item in self.items:
		print("   " + str(item))

# Sets the item in i index to null if the item is empty
func remove_used_item(i:int):
	if(self.items[i].IsEmpty):
		self.items[i] = null
	
func process_items():
	# Input and activate
	for i in range(5):  # handles clicking 1-5 and activate item if not null
		var action_name = "item" + str(i + 1)
		if Input.is_action_just_pressed(action_name) and self.items.size() > i:
			if self.items[i] != null:
				self.items[i].activate()
				remove_used_item(i)
				print_items()
