extends Monster2D

class_name ToasterBoss

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d = $AnimatedSprite2D

var bossSkills = {
	"Explosion": {"CoolDown":15, "SinceActive":0, "Skill":Explosion.new(self, 25)},
	"Laser": {"CoolDown":20, "SinceActive":0, "Skill":Laser.new(self, 15)},
	"Avenger": {"CoolDown":6, "SinceActive":0, "Skill":Avenger.new(self, 10)},
	"Balls": {"CoolDown":30, "SinceActive":0, "Skill":Balls.new(self, 10)},
}

func _ready():
	super._ready()
	hp = 30000
	for i in bossSkills.keys():
		self.add_child(bossSkills[i]["Skill"])

func determine_action():
	var random_action = self.possilbe_actions[randi_range(0, possilbe_actions.size()-1)]
	
	match random_action:
		"idle":
			self.speed = 0
			animated_sprite_2d.play("idle")
			self.current_action = "idle"
		"attack":
			self.find_player()
			self.current_action = "attack"
			self.speed = 0
			for i in bossSkills.keys():
				if(bossSkills[i]["SinceActive"] > 0):
					continue 
				bossSkills[i]["SinceActive"] = bossSkills[i]["CoolDown"]
				bossSkills[i]["Skill"].activate()
				self.current_action_time = bossSkills[i]["Skill"].ATTACK_WARNING
				animated_sprite_2d.play("attack")
				return
		"walk":
			self.speed = 60
			self.current_action = "walk"
			animated_sprite_2d.play("run")
			self.find_player()

func _process(delta):
	super._process(delta)
	for i in bossSkills.keys():
		if(bossSkills[i]["SinceActive"] > 0):
			bossSkills[i]["SinceActive"] -= delta
			continue 

func _physics_process(delta):
	if(self.current_action_time > 0):
		self.current_action_time -= delta
	else:
		self.current_action_time = ACTION_CD
		determine_action()
		
	if hp <= 0:
		animated_sprite_2d.play("die")

