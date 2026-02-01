extends Sprite2D

@export var speed: float = 1300.0

func _process(delta):

	var screen_rect = get_viewport().get_visible_rect()

	var half_width = (texture.get_width() * scale.x) / 4.0
	var half_height = (texture.get_height() * scale.y) / 4.0
	
	position.x = clamp(position.x, half_width, screen_rect.size.x - half_width)
	position.y = clamp(position.y, half_height, screen_rect.size.y - half_height)

	var input_vector = Input.get_vector("P1_cross_move_left", "P1_cross_move_right", "P1_cross_move_up", "P1_cross_move_down")
	position += input_vector * speed * delta

	if Input.is_action_pressed("P1_cross_shoot"):
		modulate = Color.WHITE
	else:
		modulate = Color.RED
