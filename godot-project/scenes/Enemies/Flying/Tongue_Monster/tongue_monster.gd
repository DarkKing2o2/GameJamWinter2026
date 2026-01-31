extends CharacterBody2D

## For debugging
@export var godMode : bool = false
@export var print_states = false
@export var print_collisions = false


## Vars to be accessed by children somewhere.
@onready var anime_player := $AnimationPlayer
@onready var detectionbox = $DualPurposeBox
@onready var anime_sprite := $AnimatedSprite2D

## Var for script state machine
var state_machine : StateMachine

var health = Health # enemy health
# var damage_multiplier: int = 5 # so that it doesn't 10 hits to kill enemy. address later

var _frames_since_facing_update: int = 0
var _moved_this_frame: bool = false

## Var for speed.
# TODO: Make part of some class called stats.
@export var speed: float = 100.0
## Var for spot_range.
# TODO: Make part of some class called stats.
var _spotRange = 400
## Var for attackRange. Dictates the distance between the enemy and player at
##	which the enemy will stop and begin his attack.
var _attackRange = 80
var target

## Var for the BTPlayer Node
@export var _btPlayer : BTPlayer
## Var for the blackboard of vars that'll be appended to the blackboard plan
var _blackBoard : Blackboard = Blackboard.new()

## One time reference signal to act as a _ready() function for LimboAI custom
##	tasks.
signal blackboardTargetUpdatedSignal

#chance in percent for enemy to drop xp on death
var xp_drop_chance:int = 50
# xpdrop scene
var xp_drop_scene = preload("res://scenes/entities/xp_drop.tscn")

## #Var for the attack
var _attackScene = preload("res://scenes/Enemies/Flying/Tongue_Monster/tongue_swipe_effect.tscn")
var _attack

func _init() -> void:
	# Setup the animation player since it doesn't suffer from race conditions
	self._attack = self._attackScene.instantiate()
	# Do typical stuff
	self.add_child(_attack)
	_attack.set_owner(self)
	# Set its internal owner var
	_attack.set_Owner(self)
	# Scale it down to be more sized like the enemy.
	_attack.set_scale(Vector2(0.3,0.3))



## Function() for setting the bt player to monster. Reason is that it requires
##	the target, so need the reference to the player otherwise race condition.
func _setup_BlackBoard() -> void:
	##### Behaviour Tree #####
	#The behavior_tree is only initialized when active is true and the agent's
	#	local scene root node is ready. If BTPlayer becomes active before the
	#	scene root node is ready, initialization is delayed until then. When
	#	active is false, initialization is postponed until activation.
	# Add a new blackboard: it's just an object that stores a blackboard, which is
	#	a key value storage object for storing and managing variables that any
	#	node within the HSM can access

	# A StringName is optimized for fast comparisons and lookups.
	# Stores a unique ID for the string, so comparing two StringNames is much
	# 	faster than comparing two normal strings.
	# The & in &"<String>" converts the String into a Stringname
	# Very helpful website https://deepwiki.com/limbonaut/limboai
	# Diagram : res://assets/LimboAI/Docs/Visual_Reference/LimboAIRunTimeSystemVisual.png
	self._btPlayer.blackboard.set_var(&"spotRange", self._spotRange)
	self._btPlayer.blackboard.set_var(&"attack", self._attack)
	self._btPlayer.blackboard.set_var(&"attackPlayer", self._attack.get_Anime_Player())
	# self._btPlayer.get_bt_instance().get_blackboard().set_var(&"spotRange",self._spotRange)
	# self._btPlayer.get_bt_instance().get_blackboard().set_var(&"attackRange", self._attackRange)
	self._btPlayer.blackboard.set_var(&"attackRange", self._attackRange)
	var dictVars = self._btPlayer.blackboard.get_vars_as_dict()
	# Still need the target to be added; handled by ref vendor.
	# Now prior to starting it, call the method that checks on end and if the
	#	instance of a player exists in the refvendor, it'll assign it to the
	#	blackboard, allowing the behaviour tree to reference a 'target'
	##########################

func _ready() -> void:

	##### ENEMY HEALTH #####
	if godMode:
		health = Health.new(9999999999)
	else:
		health = Health.new(10)

	##########################

	# Add vars to blackboard :
	self._setup_BlackBoard()
	# Pass off problem of target reference to ref vendor.
	RefVendor.SubscribeToNotification(self , ReferenceVendor.ID.PLAYER)


func _physics_process(_delta: float) -> void:
	_post_physics_process.call_deferred(_delta)


func _post_physics_process(_delta) -> void:
	if not _moved_this_frame:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	_moved_this_frame = false

## Method() that's part of the base Entity Script. Default is provided, however
##	should there be a need, it can be overwritten.
## Assumes:
##	1. Provided vector is normilized.
func move(direction_vector : Vector2) -> void:
	var new_velocity = direction_vector * speed * 2
	self.velocity = lerp(velocity, new_velocity, 0.2)
	move_and_slide()
	_moved_this_frame = true

## Update agent's facing in the velocity direction.
func update_facing() -> void:
	_frames_since_facing_update += 1
	if _frames_since_facing_update > 3:
		face_dir(velocity.x)

## Face specified direction.
func face_dir(dir: float) -> void:
	if dir > 0.0 and self.scale.x < 0.0:
		self.scale.x = self.scale.x * 1.0;
		_frames_since_facing_update = 0
	if dir < 0.0 and self.scale.x > 0.0:
		self.scale.x = self.scale.x * -1.0;
		_frames_since_facing_update = 0

## Returns 1.0 when agent is facing right.
## Returns -1.0 when agent is facing left.
func get_facing() -> void:
	return signf(self.scale.x)



func _process(_delta: float) -> void:
	pass

## Function for taking damage.
func take_damage(damage : int):
	self.health.take_damage(damage) # give player buff against enemies
	self.state_machine.change_state("hurt_state_monster")
	MusicManager.enemy_hurt()

## Generic function to process hits. Takes the box that hit it and depending
##	on certain factors, either discards the box or does something with it.
func collision(collisionBox : Box) -> void:
	# If hitbox is another enemy, just call bonk
	if collisionBox.is_in_group("enemy"):
		knockback(collisionBox)
	# If hitbox is player, call bonk
	elif collisionBox.is_in_group("player"):
		knockback(collisionBox)
	elif collisionBox.is_in_group("player_weapon"):
		# Make slight alteration to what we pass. Since the collision occured
		#	with the weapon, that means bonks might be TOO real. And we want
		#	rouge like bonks. So rather than using the hitbox as the origin,
		#	use the player.
		knockback(collisionBox)

#
	## If the box's owner is a weapon or projectile, take damage.
	#if collisionBox.is_in_group("player_weapon") or collisionBox.is_in_group("player_projectile") :
		## Calc the direction of impact and set the attribute within the hurt_state to that vector.
		## Us direction in Bullet->Monster = Monster - bullet
		#state_machine.states["hurt_state_monster"].hit_dir_vector = \
			#(self.global_position - collisionBox.global_position ).normalized()
		#take_damage(collisionBox.damage)


	return

## Old Func I think
func get_current_state() -> String :
	return self.state_machine.get_current_state_name()

## Function for dropping xp.
func drop_xp():
	var rand = randi_range(1,100)
	if rand <= xp_drop_chance:
		var xp_temp = xp_drop_scene.instantiate()
		xp_temp.position = self.position
		get_tree().root.add_child(xp_temp)


## Function for debugging collisions.
func get_collisions_values()->void:
	print("MONSTER: Layer: " , $DualPurposeBox.collision_layer, " and Mask: ",
	$DualPurposeBox.collision_mask, " and Group: ", self.get_groups())
	return

## Old function from a state based state machine vs the new Limbo AI
func bonk_collision(bonker : PhysicsBody2D) -> void:
	var random_dir_change = -1 if randf() < 0.5 else 1
	# Getting a vector that goes from the position of the thing we bonked
	#	to our position. Reason is we want the vector to be a force in the
	#	direction that will drive US out of the thing we bonked.
	var bonkVector = bonker.position.direction_to(self.global_position).rotated(random_dir_change * PI/4)
	bonkVector = bonkVector.normalized()

	# Since no way to pass arguments rn, just get the state and set it's vector
	#	param to this vector.
	state_machine.states["bonk_enemy"].bonkVector = bonkVector
	#state_machine.current_state.bonkVector = bonkVector
	state_machine.change_state("bonk_enemy")

func dead_disable_listener() :
	# Setting disable on items does not work. It requires defering the call
	#	at which point its too late. Going to free the nodes instead.
	$DualPurposeBox.queue_free()
	$CollisionShape2D.queue_free()

## +Function() called by RefVendor. Needed to avoid a race conditions:
##	The custom scripts that are part of the Limbo AI system need a 
##	reference to the player. So if we initialize btPlayer (which in
##	turn runs those scripts) before we can provide that reference
##	as a variable to the blackboard, those scripts will call a void
##	variable crashing the game. In fact it won't even run.
## Earlier we registered ourselves with the RefVendor as someone who wants
##	a reference to the player. 
## When the player registers with the RefVendor, RefVendor then passes a 
## 	reference to anyone who registered with him asking for one. He does
##	this by calling THIS function.
func reference_vendor_notification_listener(instance : Object) -> void:
	self.target = instance
	# And add it to the black board
	self._blackBoard.set_var(&"target", self.target)

	# Now add this blackboard to be the base blackboard in our BTPlayer object
	self._btPlayer.blackboard.set_var(&"target",self.target)
	var dictVars = self._btPlayer.blackboard.get_vars_as_dict()
	# Now activate the BTPlayer
	self._btPlayer.set_active(true)
	return

## -Function for applying knockback to self. Copy of the bonk-enemy state.
func knockback( collidingBox : Box) -> void:
	var random_dir_change = -1 if randf() < 0.5 else 1
	# Getting a vector that goes from the position of the thing we bonked
	#	to our position. Reason is we want the vector to be a force in the
	#	direction that will drive US out of the thing we bonked.
	# NOTE: Position vs global_position is important. Position seems to be 0,0
	#	no matter what, for the sword. I think it's in the wording "relative to
	#	the parent". Whereas the global position is correct and thus all calculated
	#	directional vectors work as expected.
	var bonkVector = collidingBox.owner.position.direction_to(self.global_position).rotated(random_dir_change * PI/4)
	bonkVector = self.global_position - collidingBox.owner.global_position
	bonkVector = bonkVector.normalized() * 300

	# Create our own apply_impulse method of sorts.
	get_tree().create_tween().tween_property(self,"velocity",bonkVector,1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
