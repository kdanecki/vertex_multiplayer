extends PlayerBase

var all_poles = []

var held_pole
var pole_base

var super_counter = 0

@rpc("any_peer", "call_local", "reliable")
func shoot(dir):
	if not is_on_floor():
		super_counter += 1
	else:
		super_counter = 0
		
	pole(dir)
		
	if super_counter >= 4:
		print("POLE LAYER!!!!")
		super_counter = 0
		for pole in self.all_poles.slice(0, -3):
			pole.freeze = false
			pole.gravity_scale = 1
			pole.mass = 2

@rpc("any_peer", "call_local", "reliable")
func pole(dir):
	if self.held_pole:
		self.held_pole.freeze = true
		all_poles.append(self.held_pole)
		
		self.held_pole = null
		self.pole_base.queue_free()
		
		self.health += 10
		
	else:
		self.held_pole = preload("res://pole.tscn").instantiate()
		self.pole_base = preload("res://pole_base.tscn").instantiate()
		get_parent().add_child(self.held_pole, true)
		get_parent().add_child(self.pole_base, true)
		self.held_pole.position = position + dir
		self.held_pole.rotation = Vector3( 0, self.rotation.y, 0 )
		self.pole_base.position = position + dir
		self.pole_base.rotation = Vector3( 0, self.rotation.y, 0 )
	
	

func _process(delta):
	pass
