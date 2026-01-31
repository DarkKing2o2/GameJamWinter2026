@icon("res://assets/Script_Icons/scripts/static_scrip_icon.jpg")

class_name GameInputEvents extends Node

static func movement_input() -> Vector2:
	var direction : Vector2
	direction.x = Input.get_axis("ui_left","ui_right")
	direction.y = Input.get_axis("ui_up","ui_down")
	return direction

static func sprint_input() -> bool :
	var sprint_input : bool = Input.is_action_pressed("sprint")
	return sprint_input

static func shoot_fireball_input() -> bool :
	var shoot_fireball_input : bool = Input.is_action_just_pressed("shoot_fireball")
	return shoot_fireball_input

static func mouse_click_input() -> bool :
	var mouse_clicked : bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	return mouse_clicked

## Function for obtaining a Vector representing the direction to the mouse
##	given some origin.
static func dir_to_mouse_input( origin ) -> Vector2:
	# Calc Origin->Mouse-> vector.
	var mouse_direction : Vector2 = (origin.get_global_mouse_position() - origin.global_position).normalized()
	return mouse_direction
