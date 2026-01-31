extends RigidBody2D

## For debugging
@export var godMode : bool = false
@export var print_states = false
@export var print_collisions = false

@onready var area_box = $HitHurtBox

var health = Health # enemy health

@export var speed: float = 200.0
@onready var target = self.get_tree().get_first_node_in_group("player")

#chance in percent for enemy to drop xp on death
var xp_drop_chance:int = 50
# xpdrop scene
var xp_drop_scene = preload("res://scenes/entities/xp_drop.tscn")


func _ready() -> void:
	health = Health.new(100)
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	var direction = (target.global_position - self.global_position).normalized()
	self.apply_force( direction * speed * 5000 * delta , self.position)

func take_damage(damage : int):
	self.health.take_damage(damage) # give player buff against enemies

## Generic function to process hits. Takes the box that hit it and depending
##	on certain factors, either discards the box or does something with it.
func collision(hitbox : Box) -> void:
	# If hitbox is player, call bonk
	if hitbox.is_in_group("player"):
		bonk_collision(hitbox.owner)

	return

## Function that determines if the monster should drop xp and spawn it if it should
func drop_xp():
	var rand = randi_range(1,100)
	if rand <= xp_drop_chance:
		var xp_temp = xp_drop_scene.instantiate()
		xp_temp.position = self.position
		get_tree().root.add_child(xp_temp)

func bonk_collision(bonker : PhysicsBody2D) -> void:
	var random_dir_change = -1 if randf() < 0.5 else 1
	# Getting a vector that goes from the position of the thing we bonked
	#	to our position. Reason is we want the vector to be a force in the
	#	direction that will drive US out of the thing we bonked.
	var bonkVector = bonker.position.direction_to(self.global_position).rotated(random_dir_change * PI/4)
	bonkVector = bonkVector.normalized()
