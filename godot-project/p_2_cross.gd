extends Sprite2D

@export var speed: float = 1300.0

func _process(delta):
	var input_vector = Input.get_vector("P2_cross_move_left", "P2_cross_move_right", "P2_cross_move_up", "P2_cross_move_down")
	position += input_vector * speed * delta
