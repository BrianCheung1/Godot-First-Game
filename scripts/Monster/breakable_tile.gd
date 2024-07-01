extends Monster2D
class_name BreakableTile

var locked_position

func _ready():
	super._ready()
	locked_position = position

func _physics_process(delta):
	position = locked_position
	
func _process(delta):
	pass
	
func hit(damage: int):
	super.hit(damage)
	mini_hpbar.hide()
