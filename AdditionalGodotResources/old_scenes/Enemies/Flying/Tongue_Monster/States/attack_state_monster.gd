extends StateInterface

class_name AttackStateMonster

var character : Node2D
var anime_player : AnimationPlayer
var slow_down_speed : int = 12

func ready() -> void:
	character = state_machine.owner
	anime_player = state_machine.owner.anime_player

func enter (prev_state : String = "") -> void:
	anime_player.play("idle")

func physics_update(delta):
	pass

func exit() -> void:
	anime_player.stop()

func handle_input ():
	pass
