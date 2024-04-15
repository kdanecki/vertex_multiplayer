extends MultiplayerSynchronizer

@export var direction: Vector2
@export var yaw: float
@export var pitch: float 

@export var mouse_sensitivity := 1
var total_pitch: float;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(get_multiplayer_authority() == get_multiplayer().get_unique_id());
	set_process_input(get_multiplayer_authority() == get_multiplayer().get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if Input.is_action_just_pressed("jump"):
		rpc_id(1, "jump")
	if Input.is_action_just_pressed("shoot"):
		get_parent().rpc_id(1, "shoot", $"../Camera3D".project_ray_normal(get_viewport().get_mouse_position()))
	if Input.is_action_just_pressed("toggle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

@rpc("any_peer", "reliable", "call_local")
func jump():
	if get_parent().is_on_floor():
		get_parent().velocity.y = get_parent().JUMP_VELOCITY

@rpc("any_peer", "reliable", "call_local")
func rotate(yaw, pitch):
	$"..".rotate_y(deg_to_rad(-yaw));

func _input(event):
	var motion = event as InputEventMouseMotion
	if motion:
		yaw = motion.get_relative().x * mouse_sensitivity;
		pitch = motion.get_relative().y * mouse_sensitivity;
		rpc_id(1, "rotate", yaw, pitch)
		pitch = clamp(pitch, -90 - total_pitch, 90-total_pitch);
		total_pitch += pitch;
		$"../Camera3D".rotate_object_local(Vector3(1, 0, 0), deg_to_rad(-pitch));
