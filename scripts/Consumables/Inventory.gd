extends Node

class_name Inventory

@export var items:Array[Item] = []
const MAX_SLOT = 15

# Constructor for the Inventory class
func _init(new_items: Array[Item] = []):
	if(len(new_items) > MAX_SLOT):
		push_error("Error: Initializing inventory with too many slots. Maximum allowed is %d." % MAX_SLOT)
		return 
		
	self.items = new_items

func _condense_item(item: Item) -> bool:
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].Name == item.Name:
			self.items[i].Quantity += item.Quantity
			return true
	return false

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
	print_items()

func _remove_used_items():
	for i in range(self.items.size()):
		if self.items[i] != null and self.items[i].IsEmpty:
			self.items[i] = null

func print_items():
	print("Listing all items:")
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
