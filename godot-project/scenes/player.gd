extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var player_color = Color(1, 1, 1)
@export var ignore_nodes: Array[CollisionObject3D] = []

var target_velocity = Vector3.ZERO

var can_shoot = true

var player_num
var attack
var timer

@onready var crosshair = self.get_node("Crosshair")

func _ready() -> void:
	player_num = self.name.right(1)
	attack = get_node("Attack_" + player_num)
	timer = get_node("Attack_Timer_" + player_num)
	crosshair.set_ignore_nodes(ignore_nodes)

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
	if event.is_action_pressed("Ability-GamePad" + player_num):
		pass

func shoot():
	if not can_shoot:
		return
	
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	
	var crosshair_world_pos = crosshair.get_world_position(camera)
	
	var shoot_direction = (crosshair_world_pos - global_transform.origin).normalized()
	
	var projectile_scene = preload("res://scenes/ShottyBlast.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.global_transform.origin = global_transform.origin
	
	var projectile_transform = projectile.global_transform
	var new_transform = Transform3D.IDENTITY.looking_at(shoot_direction, Vector3.UP)
	projectile.global_transform = new_transform.translated(global_transform.origin)
	
	get_parent().add_child(projectile)

func _on_attack_timer_0_timeout() -> void:
	can_shoot = true
