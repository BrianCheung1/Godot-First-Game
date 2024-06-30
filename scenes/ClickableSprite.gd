extends Sprite2D

var determine_index = {}
var index = -1
var delay = 0.1
var original_position = Vector2.ZERO  # Store original position
var is_dragging = false
var drag_tween = null  # Tween for dragging animation

func _ready():
	# Initialize determine_index map
	for i in range(1, 16):
		var slot_name = "Slot" + str(i)
		determine_index[slot_name] = i - 1
	
	# Get parent slot name and determine index
	var parent_slot_name = get_parent().get_parent().get_name()
	self.index = determine_index[parent_slot_name]
	
	# Store original position
	original_position = position
	print("Original Position:", original_position)

func _physics_process(delta):
	if is_dragging:
		var tween = get_tree().create_tween()
		var offset = get_global_mouse_position() - global_position
		tween.tween_property(self, "position", position + offset, delay)

func find_inventory():
	var node = self
	while node and not node.has_method("set_index_dragging"):  # Replace "set_index_1" with your condition
		node = node.get_parent()
	return node

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				is_dragging = true
				var inventory = find_inventory()
				inventory.set_index_dragging(self.index)
		else:
			if is_dragging:
				is_dragging = false
				get_tree().create_tween().tween_property(self, "position", original_position, delay)
			elif get_rect().has_point(to_local(event.position)):
				find_inventory().swap_item_index(self.index)

