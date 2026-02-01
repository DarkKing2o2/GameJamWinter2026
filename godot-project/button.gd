extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://party2.tscn")
	pass

func _input(event) -> void:
	if event.is_action_pressed("Attack-GamePad0"):
		get_tree().change_scene_to_file("res://party2.tscn")
	pass
