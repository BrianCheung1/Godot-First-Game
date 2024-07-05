extends Control
class_name  DisplayItems

var logger:Logger
var item:TextureRect
var item_name:Label
var item_description:Label
var item_quantity:Label
var buy_button:Button
var node_dict:Dictionary
var items:Dictionary
var tree
var hbox:HBoxContainer
var vbox:VBoxContainer
var is_player_items:bool
signal ON_BUY(key)
signal ON_SELL(key)

func _init(items:Dictionary, tree):
	self.items = items
	self.tree = tree
	
# Called when the node enters the scene tree for the first time.
func set_items():
	logger = Logger.new("[Display Items Script]")
	for key in self.items:
		add_item(key)
	
func _on_buy_button_pressed(key):
	var node = node_dict[key]
	if self.items[key]["Quantity"] > 0:
		self.items[key]["Quantity"] -=1
		var item_quantity_label = node_dict[key][3]
		item_quantity_label.text = "x" +  str(self.items[key]["Quantity"])
		if self.tree.name == "Shop":
			ON_BUY.emit(key)
		else:
			ON_SELL.emit(key)
		if self.items[key]["Quantity"] == 0:
			node[5].queue_free()
			node_dict.erase(key)
			self.items.erase(key)
				
func add_item(key):
	hbox = HBoxContainer.new()
	vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	item = TextureRect.new()
	item.texture = self.items[key]["Image"]
	item.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item.custom_minimum_size = Vector2(32, 32)
	item.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	item_name = Label.new()
	item_name.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
	item_name.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	item_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	item_name.clip_text = true
	item_name.text = self.items[key]["Name"]
	
	item_description = Label.new()
	item_description.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
	item_description.add_theme_font_size_override("font_size", 8)
	item_description.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	item_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	item_description.text = self.items[key]["Desc"]
	item_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	item_quantity = Label.new()
	item_quantity.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
	item_quantity.add_theme_font_size_override("font_size", 8)
	item_quantity.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	item_quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	item_quantity.text = "x" + str(self.items[key]["Quantity"])
	
	buy_button = Button.new()
	buy_button.text = "Buy" if self.tree.name == "Shop" else "Sell"
	buy_button.pressed.connect(_on_buy_button_pressed.bind(key))
	buy_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	buy_button.focus_mode = Control.FOCUS_NONE
	
	tree.add_child(hbox)
	hbox.add_child(item)
	hbox.add_child(vbox)
	vbox.add_child(item_name)
	vbox.add_child(item_description)
	hbox.add_child(item_quantity)
	hbox.add_child(buy_button)
	node_dict[key] = [item, item_name, item_description, item_quantity, buy_button, hbox]
