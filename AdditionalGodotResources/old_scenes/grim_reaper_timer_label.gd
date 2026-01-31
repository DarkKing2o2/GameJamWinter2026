extends Label

var time_left: float

func _ready() -> void:
	self.text = str(set_time())

func _process(_delta: float) -> void:
	self.text = str(set_time())

func set_time() -> float:
	time_left = $Grim_Reaper_Timer.time_left
	time_left = round(time_left * 100.0) / 100.0
	return time_left
