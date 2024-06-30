extends Node

class_name Inventory

@export var items:Array[Item] = []

@onready var inventory_gui_containers:Array[VBoxContainer] = [$NinePatchRect/GridContainer/Slot1/VBoxContainer, $NinePatchRect/GridContainer/Slot2/VBoxContainer,  $NinePatchRect/GridContainer/Slot3/VBoxContainer,  $NinePatchRect/GridContainer/Slot4/VBoxContainer,  $NinePatchRect/GridContainer/Slot5/VBoxContainer,
													 $NinePatchRect/GridContainer/Slot6/VBoxContainer, $NinePatchRect/GridContainer/Slot7/VBoxContainer, $NinePatchRect/GridContainer/Slot8/VBoxContainer, $NinePatchRect/GridContainer/Slot9/VBoxContainer, $NinePatchRect/GridContainer/Slot10/VBoxContainer,
													 $NinePatchRect/GridContainer/Slot11/VBoxContainer, $NinePatchRect/GridContainer/Slot12/VBoxContainer, $NinePatchRect/GridContainer/Slot13/VBoxContainer, $NinePatchRect/GridContainer/Slot14/VBoxContainer, $NinePatchRect/GridContainer/Slot15/VBoxContainer]
@onready var hotbar_gui_containers:Array[VBoxContainer] = [$HotBarGui/NinePatchRect/GridContainer/HotBarSlot1/VBoxContainer, $HotBarGui/NinePatchRect/GridContainer/HotBarSlot2/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot3/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot4/VBoxContainer,$HotBarGui/NinePatchRect/GridContainer/HotBarSlot5/VBoxContainer]
@onready var inventory_gui = $"."
@onready var hidden_store_GUI = $NinePatchRect

var null_sprite_texture = load("res://assets/sprites/circle.png")

const MAX_SLOT = 15
const MAX_HOT_BAR_INDEX = 4
var index_dragging = -1

func set_index_dragging(index:int):
	print("Dragging index is ", index)
	self.index_dragging = index

func _ready():
	inventory_gui.visible = true
	hidden_store_GUI.visible = false
	
	while items.size() < MAX_SLOT:
		items.append(null)
		
	for i in MAX_SLOT:
		attach_sprite(null,i)

func toggle_visibility():
	hidden_store_GUI.visible = !hidden_store_GUI.visible

func _condense_item(item: Item):
	var next_available_slot = MAX_SLOT
	
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].Name == item.Name:
			self.items[i].update_quantity(item.Quantity)
			update_sprite_label(self.items[i],i)
			return -1
			
		if(self.items[i] == null && next_available_slot > i):
			next_available_slot = i
	return next_available_slot

func update_inventory_label(item: Item, index: int):
	var label = self.inventory_gui_containers[index].get_child(1)
	if item:
		label.text = str(item.Quantity)
		return
		
	label.text = ""

func update_hotbar_label(item: Item, index: int):
	var hot_box_label = self.hotbar_gui_containers[index].get_child(1)
	if item:
		hot_box_label.text = str(item.Quantity)
		return
		
	hot_box_label.text = ""
	
func update_sprite_label(item: Item, index: int):
	update_inventory_label(item, index)
	
	if index <= MAX_HOT_BAR_INDEX:
		update_hotbar_label(item, index)
	
func swap_item_index(second_item_index:int):
	print("Swapping with index ", second_item_index)
	if(self.index_dragging == -1):
		return
		
	var holder = self.items[self.index_dragging]
	self.items[self.index_dragging] = self.items[second_item_index]
	self.items[second_item_index] = holder
	
	attach_sprite(self.items[self.index_dragging], self.index_dragging)
	attach_sprite(self.items[second_item_index], second_item_index)
	
	self.index_dragging = -1
	
	return

func update_sprite_hotbar(texture: Texture, index: int):
	if index > MAX_HOT_BAR_INDEX:
		return
	
	var hot_box_sprite = self.hotbar_gui_containers[index].get_child(0)
	hot_box_sprite.texture = texture if texture != null else null_sprite_texture
	hot_box_sprite.visible = texture != null
	hot_box_sprite.scale = Vector2(0.1, 0.1)

func update_sprite(texture: Texture, index: int):
	update_sprite_hotbar(texture, index)
	
	var sprite = self.inventory_gui_containers[index].get_child(0)
	sprite.texture = texture if texture != null else null_sprite_texture
	sprite.visible = texture != null
	sprite.scale = Vector2(0.15, 0.15)

func attach_sprite(item:Item, index:int):
	if item:
		var texture = load(item.textureSource)
		update_sprite(texture,index)
		update_sprite_label(item, index)
		
		return
	
	update_sprite(null,index)
	update_sprite_label(null, index)
		
	return

# Add item to inventory
func add_item(item: Item):
	if(item.IsEmpty):
		return
		
	var next_available_index = _condense_item(item)
	if(next_available_index == -1):
		print_items()
		return
		
	if next_available_index >= MAX_SLOT:
		push_error("Error add item: index >= %d" % MAX_SLOT)
		return
	
	self.items[next_available_index] = item
	attach_sprite(item, next_available_index)
	print_items()

func print_items():
	for item in self.items:
		print("   " + str(item))

# Sets the item in i index to null if the item is empty
func remove_used_item(i:int):
	if(self.items[i].IsEmpty):
		self.items[i] = null
		update_sprite(null,i)
		update_sprite_label(null,i)
		return
		
	update_sprite_label(self.items[i],i)
	
func process_items():
	# Input and activate
	for i in range(5):  # handles clicking 1-5 and activate item if not null
		var action_name = "item" + str(i + 1)
		if Input.is_action_just_pressed(action_name) and self.items.size() > i:
			if self.items[i] != null:
				self.items[i].activate()
				remove_used_item(i)
				print_items()
