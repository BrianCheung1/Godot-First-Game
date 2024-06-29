extends Area2D
class_name Aura

const DAMAGE = 5
const HIT_DELAY = 0.05
var enabled = true
var collided_monsters: Dictionary
var elapsed = 0

func _ready():
	#print("Aura ready")
	collided_monsters = {}
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	if not enabled: return
	elapsed += delta
	if elapsed > HIT_DELAY:
		elapsed = 0
		for monster in collided_monsters.values():
			monster.hit(DAMAGE)
			
func enable(is_enabled):
	enabled = is_enabled
	
func _on_area_entered(other: Area2D):
	if not enabled: return
	#print("Entered aura", other)
	var parent = other
	while not parent is Monster2D and parent != null:
		parent = parent.get_parent()
	if parent != null:
		collided_monsters[parent] = parent
		#print("Monster entered aura: ", parent)
		
func _on_area_exited(other: Area2D):
	if not enabled: return
	#print("Exited aura", other)
	var parent = other
	while not parent is Monster2D and parent != null:
		parent = parent.get_parent()
	if parent != null:
		collided_monsters.erase(parent)
		#print("Monster exited aura: ", parent)
