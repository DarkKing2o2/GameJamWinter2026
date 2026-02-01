extends Sprite2D

@export var speed: float = 1300.0
var ignore_nodes: Array[CollisionObject3D] = []

@onready var player = self.get_parent()
var ignore_rids: Array[RID] = []

func _ready():
	modulate = player.player_color

func _process(delta):

	var screen_rect = get_viewport().get_visible_rect()

	var half_width = (texture.get_width() * scale.x) / 4.0
	var half_height = (texture.get_height() * scale.y) / 4.0
	
	position.x = clamp(position.x, half_width, screen_rect.size.x - half_width)
	position.y = clamp(position.y, half_height, screen_rect.size.y - half_height)

	var input_vector = Input.get_vector("cross_move_left" + player.player_num, "cross_move_right" + player.player_num, "cross_move_up" + player.player_num, "cross_move_down" + player.player_num)
	position += input_vector * speed * delta

func _input(event):
	if event.is_action_pressed("Attack-GamePad" + player.player_num):
		modulate = Color.WHITE
		player.shoot()

	elif event.is_action_released("Attack-GamePad" + player.player_num):
		modulate = player.player_color

func get_world_position(camera: Camera3D) -> Vector3:
	var viewport_pos = get_viewport_transform().basis_xform(position)
	var ray_origin = camera.project_ray_origin(viewport_pos)
	var ray_direction = camera.project_ray_normal(viewport_pos)
	
	var space_state = player.get_world_3d().direct_space_state
	var physics_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * 1000, 1, ignore_rids)
	var result = space_state.intersect_ray(physics_query)
	
	if result.has("position"):
		return result.position
	else:
		return ray_origin + ray_direction * 1000

func set_ignore_nodes(nodes: Array[CollisionObject3D]) -> void:
	ignore_nodes = nodes
	ignore_rids = []
	for node in ignore_nodes:
		ignore_rids.append(node.get_rid())
