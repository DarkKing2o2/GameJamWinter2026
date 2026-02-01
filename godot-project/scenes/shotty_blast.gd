extends Node3D

## Var for holding a reference to the GPUParticles node in the scene tree.
@export var particles : GPUParticles3D
@export var reloadTimer : Timer

signal END_OF_RELOAD_SIGNAL

## Var for checking if we can shoot again.
var _canShoot : bool = true

var collision_area = null
var ignore_nodes: Array[CharacterBody3D] = []

var color: Color = Color.BLUE

func _ready():
	collision_area = $Area3D
	await get_tree().create_timer(0.2).timeout
	collision_area.monitoring = true

	# Connect the timeout (timer gets started, X seconds go by, timer
	#	emits a signal) signal of the ReloadTimer to our function which resets
	#	the boolean allowng gun to shoot again.
	reloadTimer.connect("timeout", self._RELOAD_TIMER_SIGNAL_LISTENER)

	await get_tree().create_timer(3).timeout
	queue_free()

func set_ignore_nodes(nodes: Array[CharacterBody3D]) -> void:
	ignore_nodes = nodes

func _physics_process(delta):
	var hit_players = collision_area.get_overlapping_bodies()
	for body in hit_players:
		print("Hit player:", body.name)
		if body.has_method("hit"):
			if body not in ignore_nodes:
				var force_direction = -global_transform.basis.z
				print(force_direction)
				body.hit(force_direction * 30)

## +Function() for shooting the gun
## Particle effects are set to one-shot.
func shoot():

	if self._canShoot == true :
		self._canShoot = false
		particles.emitting = true
		print("starting timer")
		self.reloadTimer.start(5)
	else :
		return


func _RELOAD_TIMER_SIGNAL_LISTENER():
	self._canShoot = true

func change_bullet_color(new_color: Color) -> void:
	$Bullets.draw_pass_1.material.albedo_color = new_color
