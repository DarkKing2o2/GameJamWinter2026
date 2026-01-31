extends PanelContainer
@export var TextLabel : Label

var is_ready : bool = false : set = _set_ready

func _set_ready(value):
	is_ready = value
	if value:
		TextLabel.text = "READY"
	else:
		TextLabel.text = "Press A to Join"
