extends Node

# Variable for the race name (useless for the time being)
@export var raceName: String
# The checkpoints order of the race
@export var raceOrder: Array
# Number of laps the race has
@export var lapsNumber: int
# Bool 
@export var isLoop: bool

# Index for the next CheckPoint in the race
var nextCheckPoint: int = 0;

# Current Lap
var currentLap: int = 1

func _ready() -> void:
	if isLoop:
		currentLap = 0
	print('start ', currentLap)

func addCheckPoint(newCheckPoint, isStart, isFinal) -> void:
	print(currentLap)
	if newCheckPoint == raceOrder[nextCheckPoint]:
		print("Correct CheckPoint")
		nextCheckPoint = (nextCheckPoint + 1) % len(raceOrder)
		if (isFinal):
			if (isStart):
				nextCheckPoint = 1;
				currentLap += 1;
				print('new lap')
			else:
				nextCheckPoint = 0;
				currentLap += 1;
				print('new lap')
	else: 
		print("Wrong Way")
	if currentLap > lapsNumber:
		print("Wooooo Race Finished")
