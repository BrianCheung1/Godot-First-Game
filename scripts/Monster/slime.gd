extends Monster2D
class_name Slime

func _ready():
	pass
		
# Overrides the original die function
func die():
	# Call the parent die function in Monster2D.gd
	super.die()
	
