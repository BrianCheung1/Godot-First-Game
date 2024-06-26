extends Node

const SERVER_PORT = 8080
#const SERVER_IP = "ec2-52-40-103-58.us-west-2.compute.amazonaws.com"
var SERVER_IP = PlayerVariables.player_ip

var multiplayer_scene = preload("res://scenes/multiplayer_player.tscn")
var _players_spawn_node
var host_mode_enabled = false
var multiplayer_mode_enabled = false
var respawn_point = Vector2(-65, -1057)
var players = {}

func become_host():
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	multiplayer_mode_enabled = true
	host_mode_enabled = true
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	_remove_single_player()
	if not OS.has_feature("dedicated_server"):
		_add_player_to_game(1)
		players[1] = 1
	
func join_as_player_2():
	print("Joining as player 2")
	print(SERVER_IP)
	multiplayer_mode_enabled = true
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	players[client_peer] = client_peer
	_remove_single_player()
	
func _add_player_to_game(id: int):
	print("Player %s joined the game" % id)
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	if not _players_spawn_node:
		_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	_players_spawn_node.call_deferred("add_child", player_to_add, true)
	
func _del_player(id: int):
	print("Player %s left the game" % id)
	if not _players_spawn_node:
		_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).call_deferred("queue_free") 

func _remove_single_player():
	print("Remove Single player")
	var player_to_remove = get_tree().get_current_scene().get_node("Player")
	if player_to_remove:
		player_to_remove.queue_free()
