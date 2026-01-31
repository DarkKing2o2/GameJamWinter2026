
class_name ProjectileShootState extends StateInterface

var character : Node2D
var anime_player : AnimationPlayer
var direction : Vector2
var speed: float = 300.0


func ready() -> void:
	# Set local character to be whomever this box is attached to.
	character = state_machine.owner
	# Set local anime_player be the AnimationPlayer of whomever this box is attached to.
	anime_player = state_machine.owner.anime_player
	# Connect our method to the signal emitted on death from the Health class.


func enter (prev_state : String = "") -> void:
	anime_player.play("shoot")
	character.apply_central_impulse(direction * speed)
	character.gravity_scale = 0.0
	character.rotation = direction.angle()


func physics_update(delta):
	pass

func exit() -> void:
	anime_player.stop()
