extends Node3D

signal anomaly_clear
	
func _on_body_entered(body):
	if body.has_method("boosted") == true:
		queue_free()
		anomaly_clear.emit()
