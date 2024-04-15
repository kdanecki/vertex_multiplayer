class_name PlayerBase
extends CharacterBody3D

@export var player := 1 :
	set(id):
		player = id
		$InputSynchronizer.set_multiplayer_authority(id)


@onready var input = $InputSynchronizer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var health := 100.0

func _ready():
	if player == multiplayer.get_unique_id():
		$Camera3D.make_current()
		$Control.visible = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = $InputSynchronizer.direction
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

@rpc("any_peer", "call_local", "reliable")
func shoot(dir):
	var bullet = preload("res://bullet.tscn").instantiate()
	bullet.player = self
	get_parent().add_child(bullet, true)
	bullet.position = position + dir
	bullet.apply_impulse(dir*30)

@rpc("authority", "call_local", "reliable")
func update_hp(hp):
	$Control/HpBar.value = hp;

func damage(d: float):
	health -= d;
	rpc_id(player, "update_hp", health)
	
