extends Area2D
class_name Aura

const DAMAGE = 5
const HIT_DELAY = 0.1
var enabled = true
var collided_monsters: Dictionary
var elapsed = 0
var logger

func _ready():
	logger = Logger.new("[aura]")
	logger.print("Aura ready")
	collided_monsters = {}
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	if not enabled: return
	elapsed += delta
	if elapsed > HIT_DELAY:
		elapsed = 0
		for monster: Monster2D in collided_monsters.values():
			monster.hit(DAMAGE)
			
func enable(is_enabled):
	enabled = is_enabled
	if enabled:
		show()
	else:
		hide()
	logger.print("Enabled=%s" % enabled)
	
func _on_area_entered(other: Area2D):
	if not enabled: return
	logger.print(["Entered aura", other])
	var parent = other
	while not parent is Monster2D and parent != null:
		parent = parent.get_parent()
	if parent != null:
		collided_monsters[parent] = parent
		#print("Monster entered aura: ", parent)
		
func _on_area_exited(other: Area2D):
	if not enabled: return
	logger.print(["Exited aura", other])
	var parent = other
	while not parent is Monster2D and parent != null:
		parent = parent.get_parent()
	if parent != null:
		collided_monsters.erase(parent)
		#print("Monster exited aura: ", parent)
