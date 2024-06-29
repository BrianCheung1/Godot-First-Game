extends Node

class_name Inventory

@export var items:Array[Item] = []

@onready var inventory_gui_containers:Array[VBoxContainer] = [$NinePatchRect/GridContainer/Slot/VBoxContainer, $NinePatchRect/GridContainer/Slot2/VBoxContainer,  $NinePatchRect/GridContainer/Slot3/VBoxContainer,  $NinePatchRect/GridContainer/Slot4/VBoxContainer,  $NinePatchRect/GridContainer/Slot5/VBoxContainer,
													 $NinePatchRect/GridContainer/Slot6/VBoxContainer, $NinePatchRect/GridContainer/Slot7/VBoxContainer, $NinePatchRect/GridContainer/Slot8/VBoxContainer, $NinePatchRect/GridContainer/Slot9/VBoxContainer, $NinePatchRect/GridContainer/Slot10/VBoxContainer,
													 $NinePatchRect/GridContainer/Slot11/VBoxContainer, $NinePatchRect/GridContainer/Slot12/VBoxContainer, $NinePatchRect/GridContainer/Slot13/VBoxContainer, $NinePatchRect/GridContainer/Slot14/VBoxContainer, $NinePatchRect/GridContainer/Slot15/VBoxContainer]
@onready var hotbar_gui_containers:Array[VBoxContainer] = [$HotBarGui/NinePatchRect/GridContainer/HotBarSlot1/VBoxContainer, $HotBarGui/NinePatchRect/GridContainer/HotBarSlot2/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot3/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot4/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot5/VBoxContainer]
@onready var inventory_gui = $"."
@onready var hidden_store_GUI = $NinePatchRect

const MAX_SLOT = 15
const MAX_HOT_BAR_INDEX = 4

func _ready():
	inventory_gui.visible = true
	hidden_store_GUI.visible = false

func toggle_visibility():
	hidden_store_GUI.visible = !hidden_store_GUI.visible

func _condense_item(item: Item) -> bool:
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].Name == item.Name:
			self.items[i].update_quantity(item.Quantity)
			update_sprite_label(str(self.items[i].Quantity),i)
			return true
	return false

func update_sprite_label(quantity:String, index:int):
	var label = self.inventory_gui_containers[index].get_child(1)
	label.text = quantity
	
	#This section handles updating the sprite in the hotbar
	if(index <= MAX_HOT_BAR_INDEX):
		var hot_box_labal = self.hotbar_gui_containers[index].get_child(1)
		hot_box_labal.text = quantity
		
	return
	

func swap_index(first_item_index:int, second_item_index:int):
	return

func update_sprite(texture:Texture, index:int):
	#This section handles updating the sprite in the inventory
	var sprite = self.inventory_gui_containers[index].get_child(0)
	sprite.texture = texture
	sprite.scale = Vector2(.15,.15)
	
	#This section handles updating the sprite in the hotbar
	if(index <= MAX_HOT_BAR_INDEX):
		var hot_box_sprite = self.hotbar_gui_containers[index].get_child(0)
		hot_box_sprite.texture = texture
		hot_box_sprite.scale = Vector2(.1,.1)
	return

func attach_sprite(item:Item, index:int):
	var texture = load(item.textureSource)
	if texture:
		update_sprite(texture,index)
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
