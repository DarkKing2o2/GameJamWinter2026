extends Control

@export var scene_to_load = null

func _ready() -> void:
	if scene_to_load:
		ResourceLoader.load_threaded_request(scene_to_load)
	else:
		push_error("No loading scene defined")

func _process(delta: float) -> void:
	var loading_progress = [] # array to hold to progress of loading 
	
	ResourceLoader.load_threaded_get_status(scene_to_load, loading_progress) 
	# gets the progress of how far next scene is loaded
	$ProgressBar.value = loading_progress[0]*100 # * 100 since value is between 0.0 and 1.0
	$ProgressLabel.text = str(round(loading_progress[0]*100)) + "%"
	
	if loading_progress[0] == 1.0:
		var loaded_scene = ResourceLoader.load_threaded_get(scene_to_load) # gets the finished loading screen as a packed scene
		SceneManager.go_to_preloaded_scene.call_deferred(loaded_scene) # pass the packed scene to SceneManager to set the current scene
