extends PlayerBase

var all_poles = []

var held_pole
var pole_base

var super_counter = 0
var super_bool = false

@rpc("any_peer", "call_local", "reliable")
func shoot(dir):
	if not is_on_floor():
		super_counter += 1
	else:
		super_counter = 0
		
	if super_counter < 4:
		pole(dir)
		
	if super_counter >= 4:
		super_counter = 0
		for pole in self.all_poles:
			pole.freeze = super_bool
			pole.gravity_scale = 1
			pole.mass = 2
			
		super_bool = not super_bool

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
