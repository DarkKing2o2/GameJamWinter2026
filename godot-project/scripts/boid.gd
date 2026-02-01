extends CharacterBody3D
class_name Boid

@export var maskA: MeshInstance3D
@export var maskB: MeshInstance3D
@export var maskC: MeshInstance3D

var move_speed = 14
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
var maskType = 'A'
var randomized = false

var model = null
var fall_acceleration = 75
@export var currentMask: MeshInstance3D = null
@export var animation: AnimationPlayer

func _ready():
	randomize()
	position = Vector3(randf_range(-20, 20), 0, randf_range(-20, 20))
	self.add_to_group("enemy")
	currentMask.visible = true

func _process(delta):
	var target_velocity = Vector3.ZERO
	var neighbors = self.get_parent().get_neighbors(self, perception_radius)

	direction += process_alignments(neighbors) * alignment_force
	direction += process_cohesion(neighbors) * cohesion_force
	direction += process_seperation(neighbors) * seperation_force
	direction += process_centralization(prey_position) * centralization_force

	if direction != Vector3.ZERO:
		$Pivot.basis = Basis.looking_at(direction)
		if animation.current_animation != "Walk":
			animation.play("Walk")
			# random phase offset
			if !randomized:
				print_debug('walk')
				randomized = true
				var len := animation.get_animation("Walk").length
				animation.seek(randf() * len, false)  # true = update immediately
	else:
		if animation.current_animation != "Idle":
			animation.play("Idle")

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

func hit():
	queue_free()

func set_current_mask(mask_type: String):
	if mask_type == 'A':
		currentMask = maskA
	elif mask_type == 'B':
		currentMask = maskB
	elif mask_type == 'C':
		currentMask = maskC
