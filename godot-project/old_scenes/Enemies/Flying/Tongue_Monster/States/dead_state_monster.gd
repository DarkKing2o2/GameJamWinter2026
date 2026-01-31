extends StateInterface

class_name DeadStateMonster

var character : Node2D
var anime_player : AnimationPlayer
var slow_down_speed : int = 12

signal disable_processing_and_visibility


func player_dead_health_listener() -> void:
	#self.character.set_modulate(Color(18.892, 0.0, 0.0, 1.0))
	#print_debug("I'm monster: " , character , " who received a dead signal from listener().
	#My health is: ", character.health.get_current_health())
	self.state_machine.change_state("dead_state_monster")

func ready() -> void:
	self.character = self.state_machine.owner
	self.anime_player = self.state_machine.owner.anime_player
	# Connect our method to the signal emitted on death from the Health class.
	self.character.health.on_death.connect(self.player_dead_health_listener)

func enter (_prev_state : String = "") -> void:
	##### On entering this function, it's all orge. #####
	# Lock state_machine just in case.
	self.state_machine.lock = true
	# Emit signal to disable all
	disable_processing_and_visibility.emit()
	# Stop any linear movement.
	self.character.linear_velocity = Vector2(0,0)
	# Player death animation.
	self.anime_player.play("dead")
	# Tween baby, tween!
	var tween = character.get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0,0.0, 0.5)
	if not self.anime_player.is_connected("animation_finished" ,end_of_animation_timeout):
			self.anime_player.animation_finished.connect(end_of_animation_timeout)


func physics_update(_delta):
	pass


func exit() -> void:
	pass
	# Will never be called, as the parent containing state_machine will be
	#	freed before that can occur. Also no calls are being made to exit() to
	#	do so. Intentional. Why bother.


## Function that gets called ONLY when the current animation is over. Does NOT
## 	prevent animation cancel glitch. For that, use lock on state_machine.
## _n is a string returned by the animation_finished signal and must be accepted
##	as a argument. Is not used; simply consumed.
func end_of_animation_timeout(_n:String):
	# No point in calling any extra things. Can result in calling a already
	#	deleted enemy.
	self.character.drop_xp()
	self.character.queue_free() # despawns enemy

func SetShader_BlinkIntensity(newValue : float):
	var animation : Animation = self.anime_player.get_animation("dead")
	var animationTrackMaterial = animation.find_track("AnimatedSprite2D:material:shader_parameter/blink_intensity", Animation.TrackType.TYPE_VALUE  )
	animation.track_set_key_value(animationTrackMaterial, 0, newValue)
