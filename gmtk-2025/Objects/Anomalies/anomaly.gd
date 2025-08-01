extends Node3D

signal anomaly_clear

func annomaly():
	queue_free()
	anomaly_clear.emit()
	
