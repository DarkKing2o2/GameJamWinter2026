extends Node

@onready var playerContainer = $PlayerContainer
var players = []

func _ready():
	get_all_players()
	for player in players:
		print_debug("Found player:", player.name)
		player.position = Vector3(randf_range(-40, 40), 0, randf_range(-40, 40))


func _process(delta):
	pass

func get_all_players() -> Array:
	players.clear()
	for child in playerContainer.get_children():
		if child is CharacterBody3D:
			players.append(child)
	return players
