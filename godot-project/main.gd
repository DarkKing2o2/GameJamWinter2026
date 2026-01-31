extends Node

const BOIDS_COUNT = 20
const TARGET_DIRECTION = Vector3(1, 0, 0) 

@onready var boid_scene = preload("res://scenes/boid.tscn")
@onready var boids_container = $Boids

var boids = []

func _ready():
	for i in BOIDS_COUNT:
		var boid = boid_scene.instantiate()
		boids_container.add_child(boid)
		boids.push_back(boid)
	
	for boid in boids_container.get_children():
		boid.boids = boids


func _process(delta):
	for boid in boids_container.get_children():
		boid.set_prey_position(TARGET_DIRECTION)
