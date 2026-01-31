extends Area2D

@export var speed: float = 100.0
var target: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	target = get_tree().get_first_node_in_group("player")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
