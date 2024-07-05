extends Node
class_name StateMachine

@export var initial_state: State
var logger = Logger.new("[state machine]")
var current_state: State
var states:  Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.on_transition.connect(on_transition)
	if not initial_state:
		logger.print("No initial state for state machine")
		return
				
	var state = states.get(initial_state.name.to_lower())
	if state:
		state.enter()
		current_state = state

func _process(delta):
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta):
	if current_state:
		current_state.update_physics(delta)
	
func on_transition(child_state: State, next_state: String):
	if child_state != current_state:
		return
	
	var new_state = states.get(next_state.to_lower())
	if not new_state:
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
