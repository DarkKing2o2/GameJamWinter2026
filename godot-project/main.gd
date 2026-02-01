extends Node

@onready var boidAScene = preload("res://scenes/boidA.tscn")
@onready var boidBScene = preload("res://scenes/boidB.tscn")
@onready var boidCScene = preload("res://scenes/boidC.tscn")
@onready var clique_container = $Cliques

var cliques = []

func _ready():
	pass

func _process(delta):
	pass
