extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

var player_num

func _ready() -> void:
	player_num = self.name.right(1)

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	var inputVector = Input.get_vector("Move_Left-GamePad" + player_num, "Move_Right-GamePad" + player_num, "Move_Down-GamePad" + player_num, "Move_Up-GamePad" + player_num)

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
	
func _input(event):
	if event.is_action_pressed("Attack-Gamepad" + "player_num"):
		pass
