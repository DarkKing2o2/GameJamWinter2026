extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.animation_finished.connect(self._reset_animation_timeout)


func _reset_animation_timeout(anime_name : String) -> void:
	self.play("RESET")
