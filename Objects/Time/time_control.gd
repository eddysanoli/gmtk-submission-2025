extends Control

@onready var minutes = $Minutes
@onready var seconds = $Seconds
@onready var mili = $Mili

func set_time(time: float) -> void:
	var mins: int =  int(time / 60.0)
	var segs: int = int(time) % 60
	var mil: float = (time - int(time))* 1000
	minutes.text = "%02d" % mins
	seconds.text = "%02d" % segs
	mili.text = "%03d" % mil
	
