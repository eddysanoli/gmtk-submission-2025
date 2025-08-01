extends RigidBody3D

@onready var player: Node3D = $Node3D
@onready var sprite = $Node3D/Sprite3D

var acceleration = 20
var steering = 1.5
var TurnSpeed := 0.1
var TurnTilt := 0.75

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

#Boost Panel Code (TO BE TESTED)
func _on_hitbox_body_entered(body):
	if body.has_method("anomaly"):
		pass #Reemplazar con body.anomaly()
	elif body.has_method("break"):
		pass #Reemplazar con body.break()
	elif body == get_node(".root/Objects/BoostPanel"):
		pass #Reemplazar por codigo para boost Pad
#		acceleration = 40
#		boostTimer.start()

func _on_boost_timer_timeout():
	acceleration = lerp(acceleration, 20, 3)
