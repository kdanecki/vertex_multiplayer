extends RigidBody3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if multiplayer.is_server():
		var target = body as PlayerBase
		if target && target != player:
			target.damage(10)
			print("bum")
		queue_free()
