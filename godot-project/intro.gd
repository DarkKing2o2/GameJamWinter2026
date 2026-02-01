extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("typewriter")
	$AudioStreamPlayer.play(0.0)
