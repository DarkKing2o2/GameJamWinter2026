extends StateInterface

class_name HurtStateMonster

## Preload blood spatter for later.
var blood_scene = preload("res://scenes/VFX/blood_spatter.tscn")
var blood

var character : Node2D
var anime_player : AnimationPlayer
var anime_sprite : AnimatedSprite2D
var slow_down_speed : int = 12
var prevState : String
var hit_dir_vector : Vector2

func ready() -> void:
	character = state_machine.owner
	anime_player = state_machine.owner.anime_player
	anime_sprite = state_machine.owner.anime_sprite



func enter (prev_state : String = "") -> void:
	# Add flash/blink effect to indicate enemy hit.
	var tween = character.get_tree().create_tween()
	tween.tween_method(SetShader_BlinkIntensity, 1.0,0.0, 0.5)

	blood = blood_scene.instantiate()
	blood.spawn_blood(hit_dir_vector)
	character.add_child(blood)
	blood.set_owner(character)

	# Create lock; only death can interupt.
	state_machine.lock = true
	# Play animation
	anime_player.play("hurt")
	# Force full animation duration.
	if not anime_player.is_connected("animation_finished" ,end_of_animation_timeout):
			anime_player.animation_finished.connect(end_of_animation_timeout)

	# Added blood spatter



func physics_update(delta):
	pass

func exit() -> void:
	anime_player.stop()

func end_of_animation_timeout(n:String):

	anime_player.play("RESET")
	state_machine.lock = false
	state_machine.change_state("idle_state_monster")

func SetShader_BlinkIntensity(newValue : float):
	#character.material.set_shader_parameter("blink_intensitiy", newValue)
	var animation : Animation = self.anime_player.get_animation("hurt")
	var animationTrackMaterial = animation.find_track("AnimatedSprite2D:material:shader_parameter/blink_intensity", Animation.TrackType.TYPE_VALUE  )
	animation.track_set_key_value(animationTrackMaterial, 0, newValue)
