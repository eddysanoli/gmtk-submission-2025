extends CSGBox3D

@export var checkName: String
@export var isStart: bool
@export var isFinal: bool

@onready var collisions = $Area3D
@onready var raceManager = %RaceManager

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	raceManager.passThroughCheck(checkName, isStart, isFinal)
	# raceManager.passThrough(checkName, isStart, isFinal)
