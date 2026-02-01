extends Sprite2D

@export var speed: float = 1300.0

@onready var player = self.get_parent()

func _process(delta):

	var screen_rect = get_viewport().get_visible_rect()

	var half_width = (texture.get_width() * scale.x) / 4.0
	var half_height = (texture.get_height() * scale.y) / 4.0
	
	position.x = clamp(position.x, half_width, screen_rect.size.x - half_width)
	position.y = clamp(position.y, half_height, screen_rect.size.y - half_height)

	var input_vector = Input.get_vector("cross_move_left" + player.player_num, "cross_move_right" + player.player_num, "cross_move_up" + player.player_num, "cross_move_down" + player.player_num)
	position += input_vector * speed * delta

	if Input.is_action_pressed("cross_shoot"):
		modulate = Color.WHITE
	else:
		modulate = player.player_color
