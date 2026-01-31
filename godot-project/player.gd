extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 400.0
@export var detection_range: float = 300.0  # Range to detect enemies
@export var auto_fire_rate: float = 0.0  # Shots per second when auto-firing

## Var for script state machine
var state_machine : StateMachine
var health: Health  # Add Health instance
var game_over_screen: Control

var speed: float = 400.0
var auto_fire_timer: float = 0.0
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	screen_size = get_viewport_rect().size

	game_over_screen = get_tree().get_first_node_in_group("game_over_screen")

	# Initialize Health
	health = Health.new()
	health.on_health_changed.connect(_on_health_changed)
	health.on_death.connect(_on_death)

	# ALL FOR SCRIPT STATE MACHINE
	# Create State Machine
	state_machine = StateMachine.new()
	state_machine.owner = self
	# Create and add states
	state_machine.add_state("idle_passive", IdleState.new())
	state_machine.add_state("walk_passive", WalkState.new())
	state_machine.add_state("run_passive", RunState.new())
	# state_machine.add_state("sword_slash", AttackState.new($AnimationPlayer, $Sword/SwordAnimationPlayer))

	# Set initial state as idle state
	state_machine.set_initial_state("idle_passive")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	#Script state machine
	state_machine.physics_update(delta)
	print("Current state: " + get_current_state())


	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction.length() > 1:
		direction = direction.normalized()

	velocity = direction * speed

	move_and_slide()




func _process(delta: float) -> void:

	# Script state machine
	state_machine.update(delta)


	var mouse_position = get_global_mouse_position()
	var player_position = self.global_position

	if Input.is_action_just_pressed("shoot"):
		shoot_projectile(mouse_position, player_position)

	# set up auto firing
	auto_fire_timer += delta
	if auto_fire_timer >= 1.0 / auto_fire_rate:
		auto_shoot()
		auto_fire_timer = 0.0

# Subtract mouse position from character position and scale it to a smaller num
	#var mouse_direction : Vector2 = (get_global_mouse_position() - global_position).normalized()
	#flip_player_to_mouse(mouse_direction)
	#rotate_weapon_to_mouse(mouse_direction)


## Gets closest enemy to player
func closest_enemy() -> Node2D:
	var player_position = self.global_position
	var closest_enemy = null
	var closest_distance = detection_range

	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies: # check how close player is to all enemies and find the closest one
		var distance = player_position.distance_to(enemy.global_position)
		if distance <= detection_range and distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy # return the closest enemy to player

## choose to shoot closest enemy or in a random direction
func auto_shoot():
	var player_position = self.global_position
	var closest_enemy = closest_enemy() # get closest enemy
	var mouse_position = get_global_mouse_position()

	if closest_enemy:
		shoot_projectile(closest_enemy().global_position, player_position)
	else:
		var random_angle = randf() * (2 * PI)
		var random_target = player_position + Vector2.from_angle(random_angle) * detection_range
		shoot_projectile(random_target, player_position)



func shoot_projectile(mouse_position: Vector2, player_position: Vector2):
	var projectile = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)

	var direction: Vector2 = Vector2.ZERO

	direction = (mouse_position - player_position).normalized()

	projectile.global_position = $Muzzle.global_position
	projectile.linear_velocity = direction * speed

	projectile.set_direction(direction)

func take_damage(amount: int) -> void:
	health.take_damage(amount)
	if health.current_health <= 0:
		_on_death()

func _on_health_changed(current_health: int) -> void:
	print("Player health: ", current_health)

func _on_death() -> void:
	print(" Player Died. ")
	game_over_screen.game_over()
	queue_free()



	### Flips player.x axis to face mouse
#func flip_player_to_mouse(m_dir : Vector2) -> void :
	## If the character is ahead of mouse
	#if m_dir.x > 0 and AnSpri2d.flip_h :
		#AnSpri2d.flip_h = false
	## If the character is behind mouse
	#elif m_dir.x < 0 and not AnSpri2d.flip_h:
		#AnSpri2d.flip_h = true
#
#func rotate_weapon_to_mouse(m_dir : Vector2) -> void :
	#sword.rotation = m_dir.angle()
	#if sword.scale.y == 1 and m_dir.x < 0 :s
		#sword.scale.y = -1
	#elif sword.scale.y == -1 and m_dir.x > 0:
		#sword.scale.y = 1
#
func get_current_state() -> String :
	return state_machine.get_current_state_name()
