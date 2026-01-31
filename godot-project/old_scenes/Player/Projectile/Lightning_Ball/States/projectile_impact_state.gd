
class_name ProjectileImpactState extends StateInterface

var character : Node2D
var anime_player : AnimationPlayer
var impact_particle_scene = preload("res://assets/VFX/Particles/bullet_collision_vfx.tscn")
var impact_particle : GPUParticles2D
var hit_dir_vector : Vector2

func ready() -> void:
	# Set local character to be whomever this box is attached to.
	character = state_machine.owner
	# Set local anime_player be the AnimationPlayer of whomever this box is attached to.
	anime_player = state_machine.owner.anime_player
	# Connect our method to the signal emitted on death from the Health class.


func enter (prev_state : String = "") -> void:
	impact_particle = impact_particle_scene.instantiate()
	impact_particle.direction_of_impact(hit_dir_vector)
	character.add_child(impact_particle)
	anime_player.play("impact")
	if not anime_player.is_connected("animation_finished" ,end_of_animation_timeout):
			anime_player.animation_finished.connect(end_of_animation_timeout)


func physics_update(delta):
	pass

func exit() -> void:
	anime_player.stop()

func end_of_animation_timeout(n:String):
	character.queue_free()
