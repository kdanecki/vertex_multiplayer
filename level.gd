extends Node2D

const SPAWN_RANDOM := 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
	
	if not OS.has_feature("dedicated server"):
		add_player(1)
	
func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func add_player(id: int):
	var character = preload("res://player.tscn").instantiate()
	character.player = id
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector2(100, 200) + pos * randf() * SPAWN_RANDOM
	character.name = str(id)
	$Players.add_child(character, true)
	
	#rpc_id(id, "spawn_character", 1, $Player/.position)
	#rpc_id(id, "spawn_character", id, character.position)
	
func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()

@rpc("authority", "reliable")
func spawn_character(id : int, new_position):
	var character = preload("res://player.tscn").instantiate()
	character.player = id
	character.position = new_position
	character.name = str(id)
	$Players.add_child(character, true)
	pass
