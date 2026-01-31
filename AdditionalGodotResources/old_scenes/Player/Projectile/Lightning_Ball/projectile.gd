extends RigidBody2D


## For debugging
@export var godMode : bool = false
@export var print_states = false
@export var print_collisions = false

## For states to access the needed items.
@onready var anime_player := $AnimationPlayer

## Var for script state machine
var state_machine : StateMachine



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("projectiles")

	# ALL FOR SCRIPT STATE MACHINE
	# Create State Machine
	state_machine = StateMachine.new()
	# Add tongue_monster as the owner of the state_machine
	state_machine.owner = self
	# Create and add states
	state_machine.add_state("projectile_shoot_state", ProjectileShootState.new())
	state_machine.add_state("projectile_impact_state", ProjectileImpactState.new())

	# Set initial state as idle state
	state_machine.set_initial_state("projectile_shoot_state")


func set_direction(direction: Vector2) -> void:
	state_machine.states["projectile_shoot_state"].direction = direction
	#state_machine.current_state.bonkVector = bonkVector
	state_machine.change_state("projectile_shoot_state")
	get_tree().create_timer(5).connect("timeout", _on_timer_timeout)



## Generic function to process hits. Takes the box that hit it and depending
##	on certain factors, either discards the box or does something with it.
func collision(collisionBox : Box) -> void:
	# if the box's owner is the player, call bonk.
	if collisionBox.is_in_group("enemy") :
		# Calc the vector that would be pointing from enemy to us. Picture a
		#	striking a wall and the dust shooting 180 to the bullets
		#	direction.
		state_machine.states["projectile_impact_state"].hit_dir_vector = \
			(self.global_position - collisionBox.global_position ).normalized()
		state_machine.change_state("projectile_impact_state")

func _on_timer_timeout():
	queue_free()
