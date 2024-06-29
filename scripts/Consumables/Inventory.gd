extends Node

class_name Inventory

@export var items:Array[Item] = []

#@onready var scene = preload("res://scenes/InventoryGUI.tscn")
@onready var inventorySlots:Array[VBoxContainer] = [$NinePatchRect/GridContainer/Slot/VBoxContainer, $NinePatchRect/GridContainer/Slot2/VBoxContainer,  $NinePatchRect/GridContainer/Slot3/VBoxContainer,  $NinePatchRect/GridContainer/Slot4/VBoxContainer,  $NinePatchRect/GridContainer/Slot5/VBoxContainer,
											 $NinePatchRect/GridContainer/Slot6/VBoxContainer, $NinePatchRect/GridContainer/Slot7/VBoxContainer, $NinePatchRect/GridContainer/Slot8/VBoxContainer, $NinePatchRect/GridContainer/Slot9/VBoxContainer, $NinePatchRect/GridContainer/Slot10/VBoxContainer,
											 $NinePatchRect/GridContainer/Slot11/VBoxContainer, $NinePatchRect/GridContainer/Slot12/VBoxContainer, $NinePatchRect/GridContainer/Slot13/VBoxContainer, $NinePatchRect/GridContainer/Slot14/VBoxContainer, $NinePatchRect/GridContainer/Slot15/VBoxContainer]

@onready var inventory_gui = $"."

const MAX_SLOT = 15

func toggle_visibility():
	inventory_gui.visible = !inventory_gui.visible

func _condense_item(item: Item) -> bool:
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].Name == item.Name:
			self.items[i].updateQuantity(item.Quantity)
			update_sprite_label(str(self.items[i].Quantity),i)
			return true
	return false

func update_sprite_label(quantity:String, index:int):
	var label = self.inventorySlots[index].get_child(1)
	label.text = quantity
	return
	
func update_sprite(texture:Texture, index:int):
	var sprite = self.inventorySlots[index].get_child(0)
	sprite.texture = texture
	sprite.scale = Vector2(.15,.15)
	return

func attach_sprite(item:Item, index:int):
	var texture = load(item.textureSource)
	if texture:
		update_sprite(texture, index)
		update_sprite_label(str(item.Quantity), index)
		
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

func print_items():
	for item in self.items:
		print("   " + str(item))

# Sets the item in i index to null if the item is empty
func remove_used_item(i:int):
	if(self.items[i].IsEmpty):
		self.items[i] = null
		update_sprite(null,i)
		update_sprite_label("",i)
		return
		
	update_sprite_label(str(self.items[i].Quantity),i)
	
func process_items():
	# Input and activate
	for i in range(5):  # handles clicking 1-5 and activate item if not null
		var action_name = "item" + str(i + 1)
		if Input.is_action_just_pressed(action_name) and self.items.size() > i:
			if self.items[i] != null:
				self.items[i].activate()
				remove_used_item(i)
				print_items()
