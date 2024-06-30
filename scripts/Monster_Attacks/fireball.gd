extends Area2D

var speed = 40
var angle = 0
var target = Vector2.ZERO
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	angle = global_position.direction_to(player.global_position)
	
func _physics_process(delta):
	global_position += angle

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
