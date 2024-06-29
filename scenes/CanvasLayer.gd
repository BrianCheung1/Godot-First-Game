extends CanvasLayer

@onready var inventory = $InventoryGui

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.close() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
			return
		inventory.open()
		return
	
