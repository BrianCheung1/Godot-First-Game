# Class extending this should override all the functions below

extends Node
class_name State

@export var character: CharacterBody2D
var logger = Logger.new("[state]")
signal on_transition(current_state: State, next_state_name: String)

func enter():
	pass
	
func exit():
	pass
	
func update(delta):
	pass

func update_physics(delta):
	pass
	
