extends Node3D
class_name Clique

@export var move_speed := 5.0:
	set(v):
		move_speed = v

@export var boid_count: int = 20
@export var alignment_force := 1.2:
	set(v):
		alignment_force = v
		_apply_params_to_boids()
@export var centralization_force_radius := 10.0:
	set(v):
		centralization_force_radius = v
		_apply_params_to_boids()

@export var cohesion_force := 0.5:
	set(v):
		cohesion_force = v
		_apply_params_to_boids()

@export var separation_force := 1.0:
	set(v):
		separation_force = v
		_apply_params_to_boids()

@export var centralization_force := 0.5:
	set(v):
		centralization_force = v
		_apply_params_to_boids()

@export var perception_radius := 200.0:
	set(v):
		perception_radius = v
		_apply_params_to_boids()
@export var path: Node3D
@export var target = Vector3(1, 0, 0)
@export var pathNodeTolerance = 7.0
@export var maskType = 'A'
@export var startPathIndex = 0

@onready var boid_scene = preload("res://scenes/boid.tscn")

var movingToPoint: Vector3
var current_index = 0

var boids: Array = [] 

func _apply_params_to_boids():
	for child in get_children():
		if not child.has_method("set_boid_params"):
			continue

		child.set_boid_params(
			alignment_force,
			centralization_force_radius,
			cohesion_force,
			separation_force,
			centralization_force,
			perception_radius
		)


func _ready():
	for i in boid_count:
		var boid = boid_scene.instantiate()
		boid.alignment_force = alignment_force
		boid.centralization_force_radius = centralization_force_radius
		boid.cohesion_force = cohesion_force
		boid.seperation_force = separation_force
		boid.centralization_force = centralization_force
		boid.perception_radius = perception_radius
		boid.set_current_mask(maskType)
		add_child(boid)
		boids.push_back(boid)
	if path != null:
		var points = path.get_children()
		if points.size() > 0:
			if movingToPoint == null || movingToPoint.is_equal_approx(Vector3()):
				movingToPoint = points[startPathIndex].position
				current_index = startPathIndex
	target = movingToPoint
	for boid in boids:
		boid.set_prey_position(target)

func _process(delta):
	if path != null:
		var points = path.get_children()
		if points.size() > 0:
			if movingToPoint == null:
				movingToPoint = points[0]

			var near_count = 0
			for boid in boids:
				if boid != null:
					if boid.position.distance_to(movingToPoint) < pathNodeTolerance:
						near_count += 1

			if near_count >= (boid_count / 4.0):
				near_count = 0
				current_index = (current_index + 1) % points.size()
				movingToPoint = points[current_index].position

			target = movingToPoint

	for boid in boids:
		if boid != null:
			boid.set_prey_position(target)

func get_neighbors(boid: Boid, view_radius: float) -> Array:
	var neighbors = []
	for other_boid in boids:
		if other_boid != null:
			if other_boid != boid and boid.position.distance_to(other_boid.position) <= view_radius:
				neighbors.append(other_boid)
	return neighbors

func remove_boid(boid: Boid) -> void:
	boids.erase(boid)
