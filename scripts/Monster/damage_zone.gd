extends Area2D

@export var damage: int

var logger
var player: Player

func _ready():
	logger = Logger.new("[damage zone]")
	#logger.print("Damage zone ready")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _process(delta):
	if player:
		player.hit(damage)
	
func _on_body_entered(body):
	if not body is Player:
		#logger.print("Damage zone entered but body is not a player")
		return
	player = body
	#logger.print("Player entered damage zone")
	
func _on_body_exited(body):
	if not body is Player:
		#logger.print("Damage zone exited but body is not a player")
		return
	player = null
	#logger.print("Player exited damage zone")
	
	
