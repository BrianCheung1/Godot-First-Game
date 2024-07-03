extends Control

var logger
var item
var item_name
var item_description
var item_quantity
var buy_button
var item_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new("[Display Shop Items Script]")
	var item_location = Vector2(size.x/8, size.y/4)
	var item_name_location = Vector2((size.x/8)*2, size.y/4)
	var item_description_location = Vector2((size.x/8)*2, size.y/4)
	var item_quantity_location = Vector2(size.x/8, size.y/4)
	var buy_button_location = Vector2((size.x/8)*2, size.y/4)
	
	for shopItem in ShopItems.items:
		item = Sprite2D.new()
		var move_y = size.y/4
		item.texture = ShopItems.items[shopItem]["Image"]
		item.scale = Vector2(0.1, 0.106)
		item.position = item_location
		item_location.y += move_y
		
		item_name = Label.new()
		item_name.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
		item_name.position = Vector2(item_name_location.x, item_name_location.y - 20)
		item_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_name.text = ShopItems.items[shopItem]["Name"]
		item_name_location.y += move_y
		
		item_description = Label.new()
		item_description.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
		item_description.add_theme_font_size_override("font_size", 8)
		item_description.position = Vector2(item_description_location.x, item_description_location.y)
		item_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_description.text = ShopItems.items[shopItem]["Desc"]
		item_description.size.x = 528
		item_description.autowrap_mode = TextServer.AUTOWRAP_WORD
		item_description_location.y += move_y
		
		item_quantity = Label.new()
		item_quantity.add_theme_font_override("font", load("res://assets/fonts/PixelOperator8.ttf"))
		item_quantity.add_theme_font_size_override("font_size", 8)
		item_quantity.position = item_quantity_location
		item_quantity.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item_quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		item_quantity.text = "x" +  str(ShopItems.items[shopItem]["Quantity"])
		item_quantity_location.y += move_y
		
		buy_button = Button.new()
		buy_button.text = "Buy"
		buy_button.position = Vector2(buy_button_location.x, buy_button_location.y + 20)
		buy_button.pressed.connect(_on_buy_button_pressed.bind(ShopItems.items[shopItem]))
		buy_button_location.y += move_y
		
		add_child(item)
		add_child(item_name)
		add_child(item_description)
		add_child(item_quantity)
		add_child(buy_button)
		item_dict[item_name.text] = item_quantity
	
func _on_buy_button_pressed(item):
	if item.Quantity > 0:
		item.Quantity -=1
		var label = item_dict[item.Name]
		label.text = "x" +  str(item.Quantity)
	else:
		logger.print("No more stock")
	
	
