class_name Sword extends Weapon

@onready var anime_player = $AnimationPlayer

func _init() -> void:
	pass

func _ready() -> void:
	weapon_name = "Death"
	add_to_group("player_weapon")
