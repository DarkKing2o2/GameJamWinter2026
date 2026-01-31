extends StateInterface

class_name BonkEnemy

var character : Node2D
var anime_player : AnimationPlayer
var target : Node2D
var target_size : int
var speed : int
var direction : Vector2
var characterBonkBox : Area2D
var bonk : Array
var bonkVector : Vector2


func ready() -> void:
	#print (state_machine.owner.get_c#var direction : Vector2lass())
	character = state_machine.owner
	anime_player = state_machine.owner.anime_player
	target = state_machine.owner.target
	speed = state_machine.owner.speed

func enter (prev_state : String = "") -> void:
	anime_player.play("idle")
	#character.apply_impulse(bonkVector * 0.0001, bonkVector)


func physics_update(delta):

	#if is_bonking():
		#var random_dir_change = -1 if randf() < 0.5 else 1
		## Getting a vector that goes from the position of the thing we bonked
		##	to our position. Reason is we want the vector to be a force in the
		##	direction that will drive US out of the Area2D of the thing we bonked.
		#bonkVector = bonk[0].position.direction_to(self.characterBonkBox.global_position).rotated(random_dir_change * PI/4)
		#bonkVector = bonkVector.normalized()
		#character.set_linear_velocity(bonkVector * delta * 400 )

	character.apply_impulse(bonkVector * 6000, bonkVector)
	state_machine.change_state("enemy_pathing1_state")
	if character.linear_velocity.is_zero_approx() :
		state_machine.change_state("enemy_pathing1_state")

func exit() -> void:
	anime_player.stop()
