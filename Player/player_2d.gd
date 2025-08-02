extends RigidBody3D

@onready var player: Node3D = $Node3D
@onready var sprite = $Node3D/Sprite3D

var acceleration = 15
var steering = 1.5
var TurnSpeed := 0.1
var TurnTilt := 0.75

var terrain = 0

var speedImpact: float
var turnDegree: float

func _ready():
	player.top_level = true

func  _physics_process(delta):
	player.global_position = global_position
	
	speedImpact = Input.get_axis("accelerate", "reverse") * -acceleration
	turnDegree = Input.get_axis("turn_right", "turn_left") * deg_to_rad(steering)
	
	_curve_effect(delta)
	player.rotate_y(turnDegree)
	apply_force(-player.global_transform.basis.z * speedImpact)
	
func _curve_effect(delta) -> void:
	var turnTiltValue = -turnDegree * linear_velocity.length() / TurnTilt
	var changeSpeed = 1
	
	if turnDegree == 0: changeSpeed = 3
	player.rotation.z = lerp(player.rotation.z, turnTiltValue, changeSpeed * delta )
	sprite.rotation.z = -lerp(player.rotation.z, turnTiltValue, changeSpeed * delta )
	
	#Change Damp value according to the terrain 
	match terrain:
		1:
			linear_damp = 5.0
		2:
			linear_damp = 8.0
		_:
			linear_damp = 3.5

func boosted():
	acceleration = 35
	%BoostTimer.start()

func _on_boost_timer_timeout():
	acceleration = 15
	
