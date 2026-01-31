extends Node2D


@onready var sword_scene = preload("res://scenes/Weapons/Melee/sword.tscn") as PackedScene
var weapon : Weapon
var equipped

## Var for script state machine
var state_machine : StateMachine


func _ready() -> void:
	weapon = sword_scene.instantiate()
	equipped = weapon
	$Hand.add_child(equipped)
	equipped.set_owner($Hand)

	#equipped = sword_scene.instantiate()
	#self.add_child(equipped)
	#equipped.set_owner(get_tree().edited_scene_root)
	#add_to_group("player_weapon")
	#equipped.add_to_group("player_weapon")


func _process(_delta: float) -> void:
	# Rotate the equiped item to the mouse. Call GameInputEvent() to obtain the
	#	vector from us to the mouse. Then call rotate_weapon() to
	rotate_weapon_to_mouse(GameInputEvents.dir_to_mouse_input(self))
	#equipped.position = self.position


	if GameInputEvents.mouse_click_input():
		equipped.anime_player.play("top_slash")


func rotate_weapon_to_mouse(directionToMouse : Vector2) -> void :
	self.rotation = directionToMouse.angle()
	if self.scale.y == 1 and directionToMouse.x < 0 :
		self.scale.y = -1
	elif self.scale.y == -1 and directionToMouse.x > 0:
		self.scale.y = 1
