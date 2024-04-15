extends Node

const PORT = 4433

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	multiplayer.server_relay = false
	
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server")
		_on_host_pressed.call_deferred()

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start server")
		return
	multiplayer.multiplayer_peer = peer
	start_game()
	
func _on_connect_pressed():
	var txt : String = $UI/VBoxContainer/HBoxContainer/Remote.text
	if txt == "":
		OS.alert("need a remote to connect")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	$UI.hide()
	get_tree().paused = false
	#print("started")
	if multiplayer.is_server():
		change_level.call_deferred(load("res://level.tscn"))

func change_level(scene: PackedScene):
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())
	
func _input(event):
	if not multiplayer.is_server():
		return
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://level.tscn"))
