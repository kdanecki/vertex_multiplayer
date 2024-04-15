extends Node2D

@export var player := 1 :
	set(id):
		player = id

func _ready():
	pass

func _process(delta):
	if multiplayer.get_unique_id() == player and Input.is_action_pressed("ui_accept"):
		print(multiplayer.get_unique_id(), " ", player)
		rpc_id(1, "move_right", 10)
	pass
	
@rpc("any_peer", "call_local", "reliable")
func move_right(speed):
	#print("foo")
	position += Vector2(speed, 0)
	pass
