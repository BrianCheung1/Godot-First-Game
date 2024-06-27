extends MultiplayerSynchronizer
@onready var player = $".."

var input_direction
var reload
var input_jump
# Called when the node enters the scene tree for the first time.
func _ready():
	#NetworkTime.before_tick_loop.connect(_gather)
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_axis("move_left", "move_right")
	reload = Input.is_action_just_pressed("reload")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("jump"):
		jump.rpc()
	if Input.is_action_just_released("jump"):
		jump_cancel.rpc() 
	#input_jump = Input.get_action_strength("jump")

func _physics_process(delta):
	input_direction = Input.get_axis("move_left", "move_right")
	reload = Input.is_action_just_pressed("reload")
#func _gather():
	#if not is_multiplayer_authority():
		#return
	#input_direction = Input.get_axis("move_left", "move_right")
	#reload = Input.is_action_just_pressed("reload")

@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true

@rpc("call_local")
func jump_cancel():
	if multiplayer.is_server():
		player.do_jump = false
