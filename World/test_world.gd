extends Node3D

var anomaly_present = false
var lap_number: int = 3
var lap_count = 1

@export var anomaly_scene: PackedScene = preload("res://Objects/anomaly.tscn")
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
@onready var anomaly_lap = randi_range(2, lap_number)

func _process(delta):
	if lap_count == anomaly_lap:
		anomaly_present = true
		generate_anomaly()
	
#Checkpoint system
#Por cada elemento del array generado por el metodo get_children() aplicado al 
#nodo padre de los checkpoints revisar si se recibe una senal 

#Una funcion adicional que tome la respuesta del sistema d checkpoints y cruzar la meta
#para verificar haber completado una vuelta

#Funciones para creear y manejar Timers al comienzo de cada vuelta 
#basicamente hacer un add_child(Timer)

func generate_anomaly():
	var new_anomaly = anomaly_scene.instantiate()
	path_follow.progress_ratio = randf()
	new_anomaly.global_transform = path_follow.global_transform
	add_child(new_anomaly)

func _on_anomaly_anomaly_clear():
	anomaly_present = false
	# you can also pick a new lap_target here if you want more spawns
