class_name player_lightning_wizard

extends CharacterBody2D

## For debugging.
@export var godMode = false
@export var canShoot = false
@export var print_collisions = false
@export var disable_collisions = false

# Matt's vars
var projectile_scene =  preload("res://scenes/Player/Projectile/Lightning_Ball/projectile.tscn") as PackedScene
@export var projectile_speed: float = 400.0
@export var game_over_screen: PackedScene

var speed: float = 400.0
var auto_fire_timer: float = 1.0
var screen_size
var health: Health

# Vlods var
## Var to players animation player node
@onready var anime_player := $AnimationPlayer
## Var to the animation player that's equipped.
@onready var weapon_anime_player = $Hand_Manager.equipped

## var to audio player to play xp pickup sound
@onready var xp_pickup_sfx = $XPPickupSFX
## var to audio player that plays step sound
@onready var step_sfx = $StepSFX
## var to timer that plays step sfx every 0.5 seconds while character is walking or running
@onready var timer_step = $StepTimer
## Var to the shooting projectile SFX audio player
@onready var projectile_sfx = $ProjectileSFX
## Var to the player hurt sfx audio player
@onready var hurt_sfx = $PlayerHurtSFX
## Var to Health Bar
@onready var bar_health = $CanvasLayer/HealthBar
## Var to EXP Bar
@onready var bar_exp = $CanvasLayer/ExperienceBar
## Var to Level Label
@onready var level_label = $CanvasLayer/TextureRect/LevelLabel

## game over instance
@onready var _game_over_instance: CanvasLayer = null

## Var for script state machine
var state_machine: StateMachine

var player_stats: PlayerStats = PlayerStats.new()

func _init() -> void:
	RefVendor.Register(self, ReferenceVendor.ID.PLAYER)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	add_to_group("player")
	screen_size = get_viewport_rect().size
	##### ALL FOR SCRIPT STATE MACHINE #####
	# Create State Machine
	state_machine = StateMachine.new()
	state_machine.owner = self

	# Initialize Health
	if godMode:
		health = Health.new(9999999999)
	else:
		health = Health.new(self.player_stats.current_max_health)
	health.on_health_changed.connect(_on_health_changed)
	health.on_max_health_changed.connect(_on_max_health_changed)
	health.on_death.connect(_on_death)

	#initialize Health Bar
	bar_health.max_value = health.max_health
	bar_health.value = health.current_health # already linked signals
	#initialize EXP Bar
	bar_exp.max_value = player_stats.experience_to_level_up
	bar_exp.value = player_stats.current_experience

	player_stats.player_stats_changed.connect(_stats_changed)
	player_stats.emit_player_stats_changed_signal()


	# Create and add states
	state_machine.add_state("idle_passive", IdleState.new())
	#state_machine.add_state("walk_passive", WalkState.new())
	#state_machine.add_state("run_passive", RunState.new())
	state_machine.add_state("hurt_passive", HurtState.new())
	state_machine.add_state("jiggle_walk", JiggleWalk.new())
	state_machine.add_state("jiggle_run", JiggleRun.new())

	# Set initial state as idle state
	state_machine.set_initial_state("idle_passive")
	#########################################

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Call the state_machines physics update function
	state_machine.physics_update(delta)

	# No movement control handling here, call GameInputEvents and the event you need
	# and add events as states.

func _process(delta: float) -> void:
	# Script state machine
	state_machine.update(delta)

	if canShoot :
		auto_fire_timer += delta
		if auto_fire_timer >= 1.0 / player_stats.current_fire_rate:
			auto_shoot()
			auto_fire_timer = 0.0

	if print_collisions :
		get_collisions_values()




	# Call the func to flip character position relative to the direction of the mouse.
	flip_player_to_mouse()


func _on_health_changed(current_health: int) -> void:
	print("Player health: ", current_health)
	bar_health.value = current_health
	$CanvasLayer/StatsRect/StatsContainer/HealthValue.set_text(
		str(health.current_health) + " / " +
		str(health.max_health)
		)

func _on_max_health_changed(max_health: int) -> void:
	print("Player max health: ", max_health)
	bar_health.max_value = max_health
	$CanvasLayer/StatsRect/StatsContainer/HealthValue.set_text(
		str(health.current_health) + " / " +
		str(health.max_health)
		)

func take_damage(damage: int):
	if disable_collisions :
		return
	state_machine.change_state("hurt_passive")
	health.take_damage(damage)
	hurt_sfx.play()
	if health.get_current_health() <= 0:
		_on_death()



## Generic function to process hits. Takes the box that hit it and depending
##	on certain factors, either discards the box or does something with it.
func collision(hitbox : Box) -> void:
	# If the hitbox is a enemy take damage
	if hitbox.is_in_group("enemy") :
		take_damage(hitbox.damage)


func _on_death() -> void:
	await get_tree().create_timer(0.6).timeout # finish hurt animation so when restarting, player isnt mid animation
	health.reset_heath()
	position = screen_size / 2
	print("Player Died. ")
	if _game_over_instance == null:
		_game_over_instance = game_over_screen.instantiate()
		# Add it to the root so it survives scene changes
		get_tree().root.add_child(_game_over_instance)

	_game_over_instance.game_over()

## Flips player.x axis to face mouse
func flip_player_to_mouse() -> void:
	# Get vector
	var m_dir = GameInputEvents.dir_to_mouse_input(self)

	# If the character is ahead of mouse
	if m_dir.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
	# If the character is behind mouse
	elif m_dir.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true


func get_current_state() -> String:
	return state_machine.get_current_state_name()

func auto_shoot():
	var player_position = self.global_position
	var closest_enemy = closest_enemy() # get closest enemy
	var mouse_position = get_global_mouse_position()

	if closest_enemy:
		shoot_projectile(closest_enemy.global_position, player_position)
	else:
		var random_angle = randf() * (2 * PI)
		var random_target = player_position + Vector2.from_angle(random_angle) * player_stats.current_detection_range
		shoot_projectile(random_target, player_position)


func closest_enemy() -> Node2D:
	var player_position = self.global_position
	var closest_enemy = null
	var closest_distance = player_stats.current_detection_range

	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies: # check how close player is to all enemies and find the closest one
		var distance = player_position.distance_to(enemy.global_position)
		if distance < player_stats.current_detection_range and distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy # return the closest enemy to player



func shoot_projectile(mouse_position: Vector2, player_position: Vector2):
	var projectile = projectile_scene.instantiate()
	# Doing an immediate call to add_child doesn't give .instantiate enough time.
	#	to instantiate.
	#var projectile = projectile_scene.instantiate()
	#get_tree().root.add_child(projectile)
	add_child( projectile )
	projectile.set_owner(self)
	projectile_sfx.play()

	var direction: Vector2 = Vector2.ZERO

	direction = (mouse_position - player_position).normalized()

	projectile.global_position = $Muzzle.global_position
	projectile.linear_velocity = direction * speed

	projectile.set_direction(direction)

func _play_xp_pickup_sfx() -> void:
	xp_pickup_sfx.pitch_scale = randf_range(0.9, 1.1)
	xp_pickup_sfx.play()


func _on_step_timer_timeout() -> void:
	step_sfx.play()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "walk" or anim_name == "run":
		timer_step.start()
	else:
		timer_step.stop()

## function to be called on picking up xp. Will play xp pickup sound and increase player stat xp by 1
func on_xp_pickup(xp_to_give: int) -> void:
	_play_xp_pickup_sfx()
	player_stats.add_experience(xp_to_give)

func _stats_changed(new_stats: Dictionary) -> void:
	level_label.text = str(new_stats["current_level"])
	bar_exp.value = new_stats["current_experience"]
	bar_exp.max_value = new_stats["experience_to_level_up"]

	$CanvasLayer/StatsRect/StatsContainer/LevelValue.set_text(str(new_stats["current_level"]))
	$CanvasLayer/StatsRect/StatsContainer/HealthValue.set_text(
		str(health.current_health) + " / " +
		str(health.max_health)
		)
	$CanvasLayer/StatsRect/StatsContainer/ExperienceValue.set_text(
		str(new_stats["current_experience"]) + " / " +
		str(new_stats["experience_to_level_up"])
		)
	$CanvasLayer/StatsRect/StatsContainer/MovementSpeedValue.set_text(str(new_stats["current_movement_speed"]))
	$CanvasLayer/StatsRect/StatsContainer/FireRateValue.set_text(str(new_stats["current_fire_rate"]))
	$CanvasLayer/StatsRect/StatsContainer/DetectionRangeValue.set_text(str(new_stats["current_detection_range"]))
	$CanvasLayer/StatsRect/StatsContainer/VitalityValue.set_text(str(new_stats["current_max_health"]))

	#update max health if vitality changes
	if player_stats.current_max_health != health.get_max_health():
		health.increase_max_health(player_stats.current_max_health - health.get_max_health())


func _on_player_level_up(new_level: int, points_to_give: int):
	get_tree().paused = true
	$CanvasLayer/LevelUpRect.visible = true
	var left_stat = randi_range(0, Enums.Stats.size() - 1) # 0 - 3
	var right_stat = randi_range(0, Enums.Stats.size() - 2) # 0- 2
	# since right rng is one less to ensure that all other stats are available, if right stat it
	# equal to or greater than left stat it increases by 1, this makes sure that all other
	# possibilities are possible without repeats
	if (right_stat >= left_stat):
		right_stat += 1


func get_collisions_values()->void:
	print("Player: Layer: " , $DualPurposeBox.collision_layer, " and Mask: ",
	$DualPurposeBox.collision_mask, " and Group: ", self.get_groups())
	return
