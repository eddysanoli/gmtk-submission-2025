extends RigidBody3D

#@onready var anim = $AnimationPlayer
@onready var car: Node3D = $Sprite3D

const ACCELERATION = 10
var steering = 1.5

var effectTurnSpeed := 0.1
var effectTurnTilt := 0.75

var speedForce: float
var turnDegree: float

func _ready():
	car.top_level = true

func  _physics_process(delta):
	car.global_position = global_position
	
	speedForce = Input.get_axis("accelerate", "reverse") * -ACCELERATION
	turnDegree = Input.get_axis("turn_right", "turn_left") * deg_to_rad(steering)
	
	_curve_effect(delta)
	car.rotate_y(turnDegree)
	apply_force(-car.global_transform.basis.z * speedForce)
	
func _curve_effect(delta) -> void:
	var turnStrenghtValue = turnDegree * linear_velocity.length() / effectTurnSpeed
	var turnTiltValue = -turnDegree * linear_velocity.length() / effectTurnTilt
	var changeSpeed = 1
	
	if turnDegree == 0: changeSpeed = 3
	
	car.rotation.y = lerp(car.rotation.y, turnStrenghtValue, changeSpeed * delta )
	car.rotation.z = lerp(car.rotation.z, turnTiltValue, changeSpeed * delta )
	
# Intento de codigo para animacion dinamica
#func _ready():
	#anim.assigned_animation = "turn_right"

	#anim.seek(anim.current_animation_length, true)
