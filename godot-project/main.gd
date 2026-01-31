extends Node

const BOIDS_COUNT = 20
const CLIQUES_COUNT = 3
const TARGET_DIRECTION = Vector3(1, 0, 0) 

@onready var boidAScene = preload("res://scenes/boidA.tscn")
@onready var boidBScene = preload("res://scenes/boidB.tscn")
@onready var boidCScene = preload("res://scenes/boidC.tscn")
@onready var clique_container = $Cliques

var cliques = []

@onready var CLIQUE_VALUES = [
	{"cohesion": 0.1, "separation": 1.0, "centralization": 0.7, "scene": boidAScene},
	{"cohesion": 0.1, "separation": 0.9, "centralization": 0.1, "scene": boidBScene},
	{"cohesion": 0.9, "separation": 0.1, "centralization": 0.2, "scene": boidCScene}
]

func _ready():
	pass

func _process(delta):
	for clique in clique_container.get_children():
		for boid in clique.get_children():
			boid.set_prey_position(TARGET_DIRECTION)
