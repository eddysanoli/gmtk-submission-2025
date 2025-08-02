extends Node
#Carrera 1
var checkPoints: Array

# Variable for the race name (useless for the time being)
@export var raceName: String
# The checkpoints order of the race
@export var raceOrder: Array

# Number of laps the race has
@export var lapsNumber: int

# The checkpoints already passed by the car in the current lap
var currentCheckPoints: Array
# Current Lap
var currentLap: int = 1

func _ready() -> void:
	checkPoints = get_children()
	print(checkPoints)

func addCheckPoint(newCheckPoint, isStart, isFinal) -> void:
	if currentCheckPoints.has(newCheckPoint):
		return
	currentCheckPoints.append(newCheckPoint)
	print(currentCheckPoints)
	if isFinal && currentCheckPoints == raceOrder:
		if currentLap < lapsNumber:
			currentCheckPoints.clear()
			currentLap += 1
			print('new lap')
		else: 
			print("Woooooo Race finished")
	
	
