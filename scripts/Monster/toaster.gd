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

const possilbe_actions = ["idle", "attack", "walk"]
#const possilbe_actions = [ "attack"]
var ACTION_CD = 2
var current_action_time = 0
var current_action:String

func _ready():
	super._ready()
	hp = 30000
	for i in bossSkills.keys():
		self.add_child(bossSkills[i]["Skill"])
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	
	self.damage_taken.connect(_on_health_changed)

func _on_health_changed(hp):
	if(current_action != "attack"):
		current_action_time = 0

func _on_animation_finished():
	animated_sprite_2d.play("idle")
	current_action_time = 0

func find_player():
	var current_player_pos = Util.find_target(self).position
	if(self.global_position.x > current_player_pos.x):
		animated_sprite_2d.flip_h = true
		direction = -1
	else:
		animated_sprite_2d.flip_h = false
		direction = 1

func determine_action():
	var random_action = possilbe_actions[randi_range(0, possilbe_actions.size()-1)]
	
	match random_action:
		"idle":
			print("idle")
			self.speed = 0
			animated_sprite_2d.play("idle")
			current_action = "idle"
		"attack":
			find_player()
			print("attack")
			current_action = "attack"
			self.speed = 0
			for i in bossSkills.keys():
				if(bossSkills[i]["SinceActive"] > 0):
					continue 
				bossSkills[i]["SinceActive"] = bossSkills[i]["CoolDown"]
				bossSkills[i]["Skill"].activate()
				current_action_time = bossSkills[i]["Skill"].ATTACK_WARNING
				animated_sprite_2d.play("attack")
				return
			
		"walk":
			self.speed = 60
			print("walk")
			current_action = "walk"
			animated_sprite_2d.play("run")
			find_player()

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

