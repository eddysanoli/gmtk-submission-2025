extends Control

@onready var stopwatch = $StopWatchControl/Total
@onready var lap_time_UI = preload("res://Objects/Time/TimeControl.tscn")
@onready var lap_time_container = $LapTimesControl/MarginContainer/VFlowContainer

func set_time(time: float) -> void:
	stopwatch.set_time(time)

func add_lap_time(time: float) -> void:
	var new_lap_time = lap_time_UI.instantiate()
	lap_time_container.add_child(new_lap_time)
	new_lap_time.set_time(time)
