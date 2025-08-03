extends Node

#Editor Variables

# Variable for the race name (useless for the time being)
@export var race_name: String
# The checkpoints order of the race
@export var race_order: Array[String]
# Number of laps the race has
@export var laps_number: int = 3
# if the race is a Loop (Same finish and start)
@export var is_loop: bool
@export var anomaly_scene: PackedScene = preload("res://Objects/anomaly.tscn")

# Local Variables

# Index for the next CheckPoint in the race
var next_check_point: int = 0;
# Current Lap
var current_lap: int = 1
var anomaly_present = false
var race_started = false
var time_elapsed = 0.0
var lap_time: Array[float] = []
var anomaly_destroyed = false

@onready var path_follow: PathFollow3D = $"../Path3D/PathFollow3D"
@onready var anomaly_lap = randi_range(2, laps_number)
@onready var timerUI = $"../CanvasLayer/TimerControl"

func _ready() -> void:
	if is_loop: 
		current_lap = 0
		print('start', current_lap)

func _process(delta) -> void:
	# display current time
	timerUI.set_time(time_elapsed)
  # Anomaly Generation
	if current_lap == anomaly_lap && anomaly_present == false && not anomaly_destroyed: 
		anomaly_present = true
		generate_anomaly()
  # Stopwatch
	if race_started == true:
		time_elapsed += delta

func save_time():
	var lap_index = current_lap -1
	var previous_time = 0;
	if len(lap_time) > 0:
		previous_time = lap_time.back()
	timerUI.add_lap_time(time_elapsed - previous_time)
	lap_time.append(time_elapsed)
	#time_elapsed = 0.0

func generate_anomaly() -> void:
	var new_anomaly = anomaly_scene.instantiate()
	path_follow.progress_ratio = randf()
	new_anomaly.global_transform = path_follow.global_transform
	new_anomaly.connect("anomaly_clear", _on_anomaly_clear)
	add_child(new_anomaly)

func _on_anomaly_clear():
	print('signal received')
	anomaly_destroyed = true
	anomaly_present = false

func passThroughCheck(newCheckPoint, isStart, isFinal) -> void:
	print('anomaly: ', anomaly_present)
	if anomaly_present: 
		return
	if newCheckPoint == race_order[next_check_point]:
		print("Correct CheckPoint")
		next_check_point = (next_check_point + 1) % len(race_order) 
		if (isStart) && race_started == false:
			race_started = true
			return
		if (isFinal && race_started):
			if (isStart):
				next_check_point = 1;
				current_lap += 1;
				save_time()
				print('new lap')
			else:
				next_check_point = 0;
				current_lap += 1;
				save_time()
				print('new lap')
	else: 
		print("Wrong Way")
   # Check if race is finished 
	if current_lap > laps_number:
		print("Wooooo Race Finished")
