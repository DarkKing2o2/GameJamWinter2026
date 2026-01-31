extends Node

const BOIDS_COUNT = 20
const CLIQUES_COUNT = 3
const TARGET_DIRECTION = Vector3(1, 0, 0) 

@onready var boid_scene = preload("res://scenes/boid.tscn")
@onready var clique_container = $Cliques

var cliques = []

func _ready():
	for i in CLIQUES_COUNT:
		var boids_container = Node3D.new()
		var boids = []
		for j in BOIDS_COUNT:
			var boid = boid_scene.instantiate()
			boids_container.add_child(boid)
			boids.push_back(boid)
		clique_container.add_child(boids_container)
		for boid in boids_container.get_children():
			boid.boids = boids

func _process(delta):
	for clique in clique_container.get_children():
		for boid in clique.get_children():
			boid.set_prey_position(TARGET_DIRECTION)
