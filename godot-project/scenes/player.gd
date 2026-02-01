extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var player_color = Color(1, 1, 1)
@export var ignore_nodes: Array[CollisionObject3D] = []
@export var animation: AnimationPlayer
@export var maskA: MeshInstance3D
@export var maskB: MeshInstance3D
@export var maskC: MeshInstance3D
@export var startingMask = "A"

var dead: bool = false


var masks: Array[MeshInstance3D]


var target_velocity = Vector3.ZERO

var can_shoot = true

var player_num
var attack
var timer
var currentMask = maskA;

@onready var crosshair = self.get_node("Crosshair")

func _ready() -> void:
	player_num = self.name.right(1)
	attack = get_node("Attack_" + player_num)
	timer = get_node("Attack_Timer_" + player_num)
	crosshair.set_ignore_nodes(ignore_nodes)
	masks = [ maskA, maskB, maskC ]
	var maskKeys = ["A", "B", "C"]
	startingMask = maskKeys[randi_range(0,2)]
	switch_mask(startingMask)


func _physics_process(delta):
	if(dead):
		move_and_collide(velocity * delta)
		return
	var direction = Vector3.ZERO

	var inputVector = Input.get_vector("Move_Left-GamePad" + player_num, "Move_Right-GamePad" + player_num, "Move_Down-GamePad" + player_num, "Move_Up-GamePad" + player_num)

	direction.x = inputVector.x
	direction.z = -inputVector.y

	if inputVector.length() < 0.5:
		if animation.current_animation != "Idle":
			animation.play("Idle")
	else:
		if animation.current_animation != "Walk":
			animation.play("Walk")

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
		if currentMask == maskA:
			switch_mask("B")
		elif currentMask == maskB:
			switch_mask("C")
		elif currentMask == maskC:
			switch_mask("A")

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
	projectile.change_bullet_color(player_color)
	projectile.connect("END_OF_RELOAD_SIGNAL", self._END_OF_TIMER_RELOAD_LISTENER)

	projectile.global_transform.origin = global_transform.origin

	var projectile_transform = projectile.global_transform
	var new_transform = Transform3D.IDENTITY.looking_at(shoot_direction, Vector3.UP)
	projectile.global_transform = new_transform.translated(global_transform.origin)
	
	## Calling shoot() on shottyBlast
	projectile.shoot()

	projectile.set_ignore_nodes([self as CharacterBody3D] as Array[CharacterBody3D])

	get_parent().add_child(projectile)
	self.can_shoot = false
	$Crosshair/reloading_lbl.visible = true
	await get_tree().create_timer(5).timeout
	$Crosshair/reloading_lbl.visible = false
	self.can_shoot = true

func hit(force):
	self.dead = true
	$CollisionShape3D.disabled = true
	var bones_sim = self.get_node("Pivot/Peep/Armature/Skeleton3D/PhysicalBoneSimulator3D")
	bones_sim.physical_bones_start_simulation()
	bones_sim.active = true
	self.velocity = force
	self.get_node("Pivot/Peep/Armature/Gun").visible = false
	await get_tree().create_timer(3.0).timeout
	queue_free()
	can_shoot = true

func switch_mask(mask):
	for m in masks:
		if m:
			m.visible = false
	if mask == "A":
		currentMask = maskA
	elif mask == "B":
		currentMask = maskB
	elif mask == "C":
		currentMask = maskC
	currentMask.visible = true

func _END_OF_TIMER_RELOAD_LISTENER():
	$Crosshair/reloading_lbl.visible = false
	print("timer done")
	pass
