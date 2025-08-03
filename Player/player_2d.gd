extends RigidBody3D

var input_enabled := false

@onready var player: Node3D = $Node3D
@onready var sprite = $Node3D/AnimatedSprite3D

var acceleration = 15
var steering = 1.5
var TurnSpeed := 0.1
var TurnTilt := 0.75

var terrain = 0

var speedImpact: float
var turnDegree: float

@onready var ground_map = get_parent().get_node("Ground Map")
var current_tile: int

func _ready():
	player.top_level = true
	set_physics_process(false)
	var rm = get_parent().get_node("RaceManager")
	rm.connect("enable_input", Callable(self, "_on_enable_input"))
	

func _physics_process(delta):
	player.global_position = global_position
	
	var player_position = player.global_position
	current_tile = ground_map.get_cell_item(player_position)
	
	speedImpact = Input.get_axis("accelerate", "reverse") * -acceleration
	turnDegree = Input.get_axis("turn_right", "turn_left") * deg_to_rad(steering)
	
	_curve_effect(delta)
	player.rotate_y(turnDegree)
	apply_force(-player.global_transform.basis.z * speedImpact)
	
func _on_enable_input():
	input_enabled = true
	set_physics_process(true)
	
func _curve_effect(delta) -> void:
	var turnTiltValue = - turnDegree * linear_velocity.length() / TurnTilt
	var changeSpeed = 1
	
	if turnDegree == 0: changeSpeed = 3
	player.rotation.z = lerp(player.rotation.z, turnTiltValue, changeSpeed * delta)
	sprite.rotation.z = - lerp(player.rotation.z, turnTiltValue, changeSpeed * delta)
	
	#Change Damp value according to the terrain 
	match current_tile:
		7:
			linear_damp = 5.0
		0:
			linear_damp = 7.0
		1:
			linear_damp = 3.5
		2:
			respawn()

func boosted():
	acceleration = 35
	%BoostTimer.start()

func _on_boost_timer_timeout():
	acceleration = 15
	
func respawn():
	var data: Array = get_parent().get_node("RaceManager").get_checkpoint()
	if data.size() < 2:
		return
	var spawn_pos: Vector3  = data[0]
	var target_pos: Vector3 = data[1]

	# --- compute flat delta on XZ  ---
	var delta: Vector3 = (target_pos - spawn_pos)
	delta.y = 0

	# --- compensates for -Z orientation ---
	var yaw: float = atan2(-delta.x, -delta.z)

	# --- teleports player to checkpoint ---
	sleeping = true
	global_position = spawn_pos
	rotation = Vector3(0, yaw, 0)
	linear_velocity  = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	sleeping = false

	player.global_position = spawn_pos
	player.rotation = Vector3(player.rotation.x, yaw, player.rotation.z)

	sprite.rotation.z = 0
