extends StateInterface

class_name IdleStateMonster

var character : Node2D
var anime_player : AnimationPlayer
var slow_down_speed : int = 12
var target : Node2D

func ready() -> void:
	character = state_machine.owner
	anime_player = state_machine.owner.anime_player
	target = state_machine.owner.target

func enter (_prev_state : String = "") -> void:
	anime_player.play("idle")

func physics_update(_delta):
	pass

	if target != null and target.is_in_group("player") :
		state_machine.change_state("enemy_pathing1_state")

func exit() -> void:
	anime_player.stop()

func handle_input ():
	pass
