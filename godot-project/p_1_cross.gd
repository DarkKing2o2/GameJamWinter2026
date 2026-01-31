extends Sprite2D

@export var speed: float = 1300.0

func _process(delta):
	var input_vector = Input.get_vector("P1_move_left", "P1_move_right", "P1_move_up", "P1_move_down")
	position += input_vector * speed * delta
