extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var player_color = Color(1, 1, 1)

var target_velocity = Vector3.ZERO

var can_shoot = true

var player_num
var attack
var timer
var crosshair

func _ready() -> void:
	player_num = self.name.right(1)
	attack = get_node("Attack_" + player_num)
	timer = get_node("Attack_Timer_" + player_num)
	crosshair = get_node("P" + player_num + "_cross")

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
	if event.is_action_pressed("Attack-GamePad" + player_num):
		if can_shoot:
			can_shoot = false
			timer.start(3)
			for x in attack.get_collision_count():
				if attack.get_collider(x).is_in_group("enemy"):
					#TODO: do the actual attack impact
					print(attack.get_collider(x))
					attack.get_collider(x).queue_free()
	if event.is_action_pressed("Ability-GamePad" + player_num):
		pass




func _on_attack_timer_0_timeout() -> void:
	can_shoot = true
