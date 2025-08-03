extends Node

signal enable_input

#Editor Variables

# Variable for the race name (useless for the time being)
@export var race_name: String
# The checkpoints order of the race
@export var race_order: Array[String]
# Number of laps the race has
@export var laps_number: int = 3
# if the race is a Loop (Same finish and start)
@export var is_loop: bool

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
var countdown = 5

@onready var number1 = preload("res://Assets/Sprites/UI/Numbers/1.png")
@onready var number2 = preload("res://Assets/Sprites/UI/Numbers/2.png")
@onready var number3 = preload("res://Assets/Sprites/UI/Numbers/3.png")
@onready var number4 = preload("res://Assets/Sprites/UI/Numbers/4.png")
@onready var number5 = preload("res://Assets/Sprites/UI/Numbers/5.png")
@onready var GO_text = preload("res://Assets/Sprites/UI/Go! - Sprite.png")
@export var anomaly_scene: PackedScene = preload("res://Objects/anomaly.tscn")
@onready var path_follow: PathFollow3D = $"../Path3D/PathFollow3D"
@onready var anomaly_lap = randi_range(2, laps_number)
@onready var timerUI = $"../CanvasLayer/TimerControl"

func _ready():
	
	$"../UserInterface/Countdown".hide()
	$"../UserInterface/AnomalyWarning".hide()
	var player = get_node("../Player")
	connect("enable_input", Callable(player, "_on_enable_input"))

	# Race Start
	start_count()
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
		
func start_count():
	$"../UserInterface/Countdown".show()
	if countdown != -1:
		$"../CountTimer".start()
	else:
		$"../UserInterface/Countdown/Label".texture = GO_text
		enable_input.emit()
		race_started = true
		$"../CountEnd".start()

func save_time():
	var lap_index = current_lap -1
	var previous_time = 0;
	if len(lap_time) > 0:
		previous_time = lap_time.back()
	timerUI.add_lap_time(time_elapsed - previous_time)
	lap_time.append(time_elapsed)

func generate_anomaly() -> void:
	$"../UserInterface/AnomalyWarning".show()
	$"../WarningTimer".start()
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
	print(race_order[next_check_point])
	if newCheckPoint == race_order[next_check_point]:
		next_check_point = (next_check_point + 1) % len(race_order)
		if (isFinal):
			if (isStart):
				next_check_point = 1;
				current_lap += 1;
			else:
				next_check_point = 0;
				current_lap += 1;
	else: 
		print("Wrong Way")
   # Check if race is finished 
	update_lap()
	if current_lap > laps_number:
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
		
func get_checkpoint() -> Array:
	# figure out which checkpoint we last passed
	var cp_index: int = next_check_point - 1
	if cp_index < 0:
		cp_index = race_order.size() - 1

	var cps: Array = get_children()
	if cp_index >= cps.size():
		push_error("get_checkpoint(): cp_index %d out of range" % cp_index)
		return []
	var cp_node: Node = cps[cp_index]

	if not cp_node.has_node("Marker3D"):
		push_error("Checkpoint #%d missing Marker3D" % cp_index)
		return []
	if not cp_node.has_node("DirectionPoint"):
		push_error("Checkpoint #%d missing DirectionPoint" % cp_index)
		return []

	var marker:       Node3D = cp_node.get_node("Marker3D")      as Node3D
	var directionPt:  Node3D = cp_node.get_node("DirectionPoint") as Node3D

	return [
		marker.global_transform.origin,
		directionPt.global_transform.origin
	]

func _on_count_timer_timeout() -> void:
	get_texture()
	print(countdown)
	countdown -= 1
	start_count()


func _on_warning_timer_timeout() -> void:
	$"../UserInterface/AnomalyWarning".hide()


func _on_count_end_timeout() -> void:
	$"../UserInterface/Countdown".hide()
	
func get_texture():
		match countdown:
			1:
				$"../UserInterface/Countdown/Label".texture = number1
			2:
				$"../UserInterface/Countdown/Label".texture = number2
			3:
				$"../UserInterface/Countdown/Label".texture = number3
			4:
				$"../UserInterface/Countdown/Label".texture = number4
			5:
				$"../UserInterface/Countdown/Label".texture = number5
	
func update_lap():
	match current_lap:
		1:
			$"../UserInterface/LapCount/Lap Number".texture = number1
		2:
			$"../UserInterface/LapCount/Lap Number".texture = number2
		3:
			$"../UserInterface/LapCount/Lap Number".texture = number3
