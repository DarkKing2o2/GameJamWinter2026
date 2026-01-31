extends Node2D

## Var for the animation player
@export var animePlayer : AnimationPlayer
## Private var for the owner
var _myOwner

## Function for setting the owner var for the attack. Used to center the attack origin
func set_Owner(_owner : Object) -> void:
	self._myOwner = _owner

## Function for getting the animationPlayer
func get_Anime_Player() -> AnimationPlayer:
	return self.animePlayer

## +Function that can be called to play the attack animation
func do_Attack() -> void:
	#self.position = self._myOwner.position
	# Rotate the entire attack scene to 'face' the direction of the target
	var rotateToTarget = self.get_angle_to(self._myOwner.target.global_position)
	print("Current rotation: ", self.rotation_degrees)
	print_debug("Angle in rad: ", rotateToTarget, " and angle in degree: ", rad_to_deg(rotateToTarget))

	self.rotate(rotateToTarget)
	#self.set_rotation(rotateToTarget)
	self.animePlayer.play("default")
	if not self.animePlayer.is_connected("animation_finished" ,_END_OF_ATTACK_LISTENER):
		self.animePlayer.animation_finished.connect(_END_OF_ATTACK_LISTENER)

## -Function that acts as a listener for the animation finished signal
func _END_OF_ATTACK_LISTENER() -> void:
	self.animePlayer.play("reset")

## +Function() for collisions.
func collision( box : Box ) -> void:
	# Check if the box we collided with is in the player group
	pass
