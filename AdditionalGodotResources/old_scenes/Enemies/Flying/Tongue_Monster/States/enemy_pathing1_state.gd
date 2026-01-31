extends StateInterface

class_name EnemyPathing

var character : Node2D
var anime_player : AnimationPlayer
var target : Node2D
var target_size : int
var speed : int
var direction : Vector2


func ready() -> void:
	#print (state_machine.owner.get_c#var direction : Vector2lass())
	character = state_machine.owner
	anime_player = state_machine.owner.anime_player
	target = state_machine.owner.target
	speed = state_machine.owner.speed

func enter (prev_state : String = "") -> void:
	anime_player.play("idle")


func physics_update(delta):

	#if is_bonking():
		#var random_dir_change = -1 if randf() < 0.5 else 1
		## Getting a vector that goes from the position of the thing we bonked
		##	to our position. Reason is we want the vector to be a force in the
		##	direction that will drive US out of the Area2D of the thing we bonked.
		#bonkVector = bonk[0].position.direction_to(self.characterBonkBox.global_position).rotated(random_dir_change * PI/4)
		#bonkVector = bonkVector.normalized()
		#character.set_linear_velocity(bonkVector * delta * 400 )

	direction = (target.global_position - character.global_position).normalized()
	character.apply_force( direction * speed * 5000 * delta , character.position)


func exit() -> void:
	anime_player.stop()
