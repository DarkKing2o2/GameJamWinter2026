extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	var inputVector = Input.get_vector("Move_Left-GamePad0", "Move_Right-GamePad0", "Move_Down-GamePad0", "Move_Up-GamePad0")

	direction.x = inputVector.x
	direction.z = -inputVector.y

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed


	if not is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	velocity = target_velocity
	move_and_slide()
