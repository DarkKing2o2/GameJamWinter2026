extends Node

var mob_scene = preload("res://scenes/Enemies/Flying/Tongue_Monster/Tongue_Monster.tscn")
var grim_scene = preload("res://scenes/Enemies/Grim_Reaper/Grim_Reaper.tscn")
@export var max_enemies: int = 50
@export var spawn_interval: float = 0.50  # Heartbeat interval (seconds)

var enemies: Array = []
var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	player = $Player
	$MobTimer.wait_time = spawn_interval
	enemies.clear()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()

func new_game():
	get_tree().call_group("enemy", "queue_free")
	enemies.clear()
	$MobTimer.start()

func _on_mob_timer_timeout() -> void:

	# remove enemies that should not exist in array
	for i in range(enemies.size() - 1, -1, -1):
		if not is_instance_valid(enemies[i]):
			enemies.remove_at(i)

	# return if we are at max number of enemies
	if max_enemies <= enemies.size():
		return

	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	add_child(mob, true)
	print(mob, mob.name)
	mob.set_owner(self)

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	#add_child(mob)
	# add new mob to enemies array
	enemies.append(mob)


func _on_grim_reaper_timer_timeout() -> void:
	var mob = grim_scene.instantiate()

	add_child(mob, true)
	print(mob, mob.name)
	mob.set_owner(self)

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
