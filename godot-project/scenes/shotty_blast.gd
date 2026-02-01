extends Node3D

## Var for holding a reference to the GPUParticles node in the scene tree.
@export var particles : GPUParticles3D
@export var reloadTimer : Timer

signal END_OF_RELOAD_SIGNAL

## Var for checking if we can shoot again.
var _canShoot : bool = true

var collision_area = null
var ignore_nodes: Array[CharacterBody3D] = []

func _ready():
	collision_area = $Area3D
	await get_tree().create_timer(0.1).timeout

	# Connect the timeout (timer gets started, X seconds go by, timer
	#	emits a signal) signal of the ReloadTimer to our function which resets
	#	the boolean allowng gun to shoot again.
	reloadTimer.connect("timeout", self._RELOAD_TIMER_SIGNAL_LISTENER)

	queue_free()

func set_ignore_nodes(nodes: Array[CharacterBody3D]) -> void:
	ignore_nodes = nodes

func _physics_process(delta):
	var hit_players = collision_area.get_overlapping_bodies()
	for body in hit_players:
		print("Hit player:", body.name)
		if body.has_method("hit"):
			print(ignore_nodes)
			print(body.get_node("CollisionShape3D"))
			if body not in ignore_nodes:
				body.hit()

## +Function() for shooting the gun
## Particle effects are set to one-shot.
func shoot():

	if self._canShoot == true :
		particles.emitting = true
		self.reloadTimer.start(5)
	else :


func _RELOAD_TIMER_SIGNAL_LISTENER():
