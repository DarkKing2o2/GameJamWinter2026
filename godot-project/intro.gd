extends AnimationPlayer

@export var audioPlayer : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("typewriter")
	audioPlayer.play(0.0)
	audioPlayer.connect("finished", _END_OF_AUDIO_LISTENER)
	
func _END_OF_AUDIO_LISTENER():
	self.get_tree().create_timer(3)
	switchScene()
	
func switchScene():
	get_tree().change_scene_to_file("res://party2.tscn")
