extends Monster2D
class_name SlimeBoss

var drop_chance_percent = 100
var logger = Logger.new("[Slime Boss]")
var possible_items = ["ExplosionItem", "AvengerItem"]

const BOSS_HP = 5000

var bossSkills = {
	"Explosion": {"CoolDown":3, "SinceActive":0, "Skill":Explosion.new(self, 5)},
	"Avenger": {"CoolDown":7, "SinceActive":0, "Skill":Avenger.new(self, 50)},
}


# Overrides the original die function
func die():
	var item = generate_random_item()
	if(item):
		super.generate_item_node(item)
	super.die()

func generate_random_item():
	if rng.randf_range(0, 100) >= drop_chance_percent:
		return null
	
	return possible_items[rng.randi_range(0, possible_items.size() - 1)]

func _ready():
	super._ready()
	self.hp = BOSS_HP
	logger.print(["HP: ", self.hp])
	for i in bossSkills.keys():
		self.add_child(bossSkills[i]["Skill"])

func _process(delta):
	super._process(delta)
	for i in bossSkills.keys():
		if(bossSkills[i]["SinceActive"] > 0):
			bossSkills[i]["SinceActive"] -= delta
			continue 
		bossSkills[i]["SinceActive"] = bossSkills[i]["CoolDown"]
		bossSkills[i]["Skill"].activate()
