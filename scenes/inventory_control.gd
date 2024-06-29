extends CanvasLayer

@onready var inventory = $InventoryGui

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.visible = false;

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = !inventory.visible
		return
