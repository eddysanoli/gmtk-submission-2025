extends Area3D

signal player_detected

func _on_body_entered(body):
	if body == $Player:
		player_detected.emit
