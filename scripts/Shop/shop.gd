extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	animation_player.play("MoveDown")


#func _on_buy_button_pressed():
	#print(ShopItems.items[0])
