extends Node3D

const SPAWN_RANDOM := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	if not multiplayer.is_server():
		return
	#multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	#for id in multiplayer.get_peers():
		#add_player(id)
	
	#if not OS.has_feature("dedicated server"):
	#	add_player(1)
	
func _exit_tree():
	if not multiplayer.is_server():
		return
	#multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

@rpc("any_peer", "call_local", "reliable")
func add_player(id: int, player: String):
	var character = load(player).instantiate()
	character.player = id
	var pos := Vector2.from_angle(randf() * 2 * PI) * randf() * SPAWN_RANDOM
	character.position = Vector3(pos.x, 0,  pos.y)
	character.name = str(id)
	$Players.add_child(character, true)
	
func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()
	
func select_1():
	print("foo")
	rpc_id(1, "add_player", multiplayer.get_unique_id(), "res://player.tscn")
	$UI.hide()
	pass

func select_2():
	rpc_id(1, "add_player", multiplayer.get_unique_id(), "res://player2.tscn")
	$UI.hide()
	pass
#@rpc("authority", "reliable")
#func spawn_character(id : int, new_position):
#	var character = preload("res://player.tscn").instantiate()
#	character.player = id
#	character.position = new_position
#	character.name = str(id)
#	$Players.add_child(character, true)
#	pass
