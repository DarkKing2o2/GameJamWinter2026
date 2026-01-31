extends Node3D
class_name Clique

@export var boid_scene: PackedScene
@export var boid_count: int = 20
@export var cohesion_force: float = 0.5
@export var separation_force: float = 1.0
@export var centralization_force: float = 0.5
@export var perception_radius: float = 200
@export var path: Path3D
@export var target = Vector3(1, 0, 0) 
@export var pathNodeTolerance = 10.0
var pointCurrentlyAt: Vector3

var boids: Array = []

func _ready():
	for i in boid_count:
		var boid = boid_scene.instantiate()
		boid.cohesion_force = cohesion_force
		boid.seperation_force = separation_force
		boid.centralization_force = centralization_force
		boid.perception_radius = perception_radius
		add_child(boid)
		boids.push_back(boid)

func _process(delta):
	if path != null:
		var points = path.get_curve().get_baked_points()
		if points.size() > 0:
			if pointCurrentlyAt == null:
				pointCurrentlyAt = points[0]  # Start at the first point

			# Check if enough boids are near the current target
			var near_count = 0
			for boid in boids:
				if boid.position.distance_to(pointCurrentlyAt) < pathNodeTolerance:
					near_count += 1

			if near_count >= boid_count / 2:  # Move to the next point if half the boids are near
				var current_index = points.find(pointCurrentlyAt)
				if current_index < points.size() - 1:
					pointCurrentlyAt = points[current_index + 1]  # Move to the next point
				else:
					pointCurrentlyAt = points[0]  # Loop back to the start

			target = pointCurrentlyAt  # Update the target for the boids

	for boid in boids:
		boid.set_prey_position(target)

func get_neighbors(boid: Boid, view_radius: float) -> Array:
	var neighbors = []
	for other_boid in boids:
		if other_boid != boid and boid.position.distance_to(other_boid.position) <= view_radius:
			neighbors.append(other_boid)
	return neighbors
