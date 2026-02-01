extends Node3D

var collision_area = null
var ignore_nodes: Array[CharacterBody3D] = []

func _ready():
	collision_area = $Area3D
	await get_tree().create_timer(0.1).timeout
	queue_free()

func set_ignore_nodes(nodes: Array[CharacterBody3D]) -> void:
	ignore_nodes = nodes
		
func _physics_process(delta):
	var hit_players = collision_area.get_overlapping_bodies()
	for body in hit_players:
		print("Hit player:", body.name)
		if body.has_method("hit"):
			print(ignore_nodes)
			print(body.get_node("CollisionShape3D"))
			if body not in ignore_nodes:
				body.hit()
	
