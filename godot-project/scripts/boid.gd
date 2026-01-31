extends CharacterBody3D
class_name Boid


var boids = []
var move_speed = 6
var perception_radius = 50
var centralization_force_radius = 10
var direction = Vector3.ZERO
var steer_force = 50.0
var alignment_force = 1.2
var cohesion_force = 0.5
var seperation_force = 1.0
var avoidance_force = 30.0
var centralization_force = 0.5
var prey_position: Vector3 = Vector3.ZERO

@export var fall_acceleration = 75

func _ready():
	randomize()
	position = Vector3(randf_range(-20, 20), 0, randf_range(-20, 20))
	velocity = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * move_speed


func _process(delta):
	var target_velocity = Vector3.ZERO
	var neighbors = get_neighbors(perception_radius)
	
	direction += process_alignments(neighbors) * alignment_force
	direction += process_cohesion(neighbors) * cohesion_force
	direction += process_seperation(neighbors) * seperation_force
	direction += process_centralization(prey_position) * centralization_force

	if direction != Vector3.ZERO:
		$Pivot.basis = Basis.looking_at(direction)

	target_velocity += direction * delta
	target_velocity = target_velocity.limit_length(move_speed)

	if not is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	velocity = target_velocity
	move_and_slide()


func set_prey_position(position: Vector3):
	prey_position = position
	
func process_centralization(center: Vector3):
	if position.distance_to(center) < centralization_force_radius:
		return Vector3()
		
	return steer((center - position).normalized() * move_speed)

func process_cohesion(neighbors):
	var vector = Vector3()
	if neighbors.is_empty():
		return vector
	for boid in neighbors:
		vector += boid.position
	vector /= neighbors.size()
	
	return steer((vector - position).normalized() * move_speed)
	

func process_alignments(neighbors):
	var vector = Vector3()
	if neighbors.is_empty():
		return vector
		
	for boid in neighbors:
		vector += boid.velocity
	vector /= neighbors.size()
	
	return steer(vector.normalized() * move_speed)
	

func process_seperation(neighbors):
	var vector = Vector3()
	var close_neighbors = []
	for boid in neighbors:
		if position.distance_to(boid.position) < perception_radius / 2:
			close_neighbors.push_back(boid)
	if close_neighbors.is_empty():
		return vector
	
	for boid in close_neighbors:
		var difference = position - boid.position
		vector += difference.normalized() / difference.length()
	
	vector /= close_neighbors.size()
	
	return steer(vector.normalized() * move_speed)
	

func steer(target):
	var steer = target - velocity
	steer = steer.normalized() * steer_force
	
	return steer
	

func get_neighbors(view_radius):
	var neighbors = []

	for boid in boids:
		if position.distance_to(boid.position) <= view_radius and not boid == self:
			neighbors.push_back(boid)
			
	return neighbors
