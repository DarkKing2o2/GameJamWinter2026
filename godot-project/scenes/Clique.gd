extends Node3D
class_name Clique

@export var boid_scene: PackedScene
@export var boid_count: int = 20
@export var alignment_force: float = 1.2
@export var centralization_force_radius: float = 10.0
@export var cohesion_force: float = 0.5
@export var separation_force: float = 1.0
@export var centralization_force: float = 0.5
@export var perception_radius: float = 200
@export var path: Node3D
@export var target = Vector3(1, 0, 0) 
@export var pathNodeTolerance = 7.0
var movingToPoint: Vector3
var current_index = 0

var boids: Array = []

func _ready():
	for i in boid_count:
		var boid = boid_scene.instantiate()
		boid.alignment_force = alignment_force
		boid.centralization_force_radius = centralization_force_radius
		boid.cohesion_force = cohesion_force
		boid.seperation_force = separation_force
		boid.centralization_force = centralization_force
		boid.perception_radius = perception_radius
		add_child(boid)
		boids.push_back(boid)
	if path != null:
		var points = path.get_children()
		if points.size() > 0:
			if movingToPoint == null || movingToPoint.is_equal_approx(Vector3()):
				movingToPoint = points[0].position
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

			if near_count >= (boid_count / 2.0):
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
