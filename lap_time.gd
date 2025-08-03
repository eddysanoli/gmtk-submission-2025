extends Control
@onready var control = $TimeControl
@onready var one = preload("res://Objects/UI Numbers/1.tscn")
@onready var two = preload("res://Objects/UI Numbers/2.tscn")
@onready var three = preload("res://Objects/UI Numbers/3.tscn")
@onready var four = preload("res://Objects/UI Numbers/4.tscn")
@onready var five = preload("res://Objects/UI Numbers/5.tscn")
@onready var six = preload("res://Objects/UI Numbers/6.tscn")
@onready var seven = preload("res://Objects/UI Numbers/7.tscn")
@onready var eight = preload("res://Objects/UI Numbers/8.tscn")
@onready var nine = preload("res://Objects/UI Numbers/9.tscn")

#
var time_images: Array 

func _ready() -> void:
	time_images = [one, two, three, four, five, six, seven, eight, nine]

func new_lap_time(lap_number: int, time: float):
		control.set_time(time)
		
	
