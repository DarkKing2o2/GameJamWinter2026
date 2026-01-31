extends Node

const BOIDS_COUNT = 20
const CLIQUES_COUNT = 3
const TARGET_DIRECTION = Vector3(1, 0, 0) 

@onready var boid_scene = preload("res://scenes/boid.tscn")
@onready var clique_container = $Cliques

var cliques = []

const CLIQUE_VALUES = [
	{"cohesion": 0.1, "separation": 1.0, "centralization": 0.7, "model_path": "res://assets/Characters/pcAvatar.blend"},
	{"cohesion": 0.1, "separation": 0.9, "centralization": 0.1, "model_path": "res://assets/Characters/pcAvatar.blend"},
	{"cohesion": 0.9, "separation": 0.1, "centralization": 0.9, "model_path": "res://assets/Characters/pcAvatar.blend"}
]

func _ready():
	for i in CLIQUES_COUNT:
		var boids_container = Node3D.new()
		var boids = []
		for j in BOIDS_COUNT:
			var boid = boid_scene.instantiate()
			boid.cohesion_force = CLIQUE_VALUES[i]["cohesion"]
			boid.seperation_force = CLIQUE_VALUES[i]["separation"]
			boid.centralization_force = CLIQUE_VALUES[i]["centralization"]
			var model = load(CLIQUE_VALUES[i]["model_path"])
			boid.get_child(0).add_child(model)
			boids_container.add_child(boid)
			boids.push_back(boid)
		clique_container.add_child(boids_container)
		for boid in boids_container.get_children():
			boid.boids = boids

func _process(delta):
	for clique in clique_container.get_children():
		for boid in clique.get_children():
			boid.set_prey_position(TARGET_DIRECTION)
