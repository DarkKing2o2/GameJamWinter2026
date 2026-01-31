# class_name SceneManager # no class name since defined in autoloads

extends Node
## This Script will function to manage switching scenes
##
## @tutorial https://docs.godotengine.org/en/latest/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
var current_scene = null # initialize to no current scene
## Note: added to global autoloads in Gofot

func _ready() -> void:
	var root = get_tree().root

	current_scene = root.get_child(-1)
	# -1 index gets the latest addition to the root, AKA the current scene/first scene

## The public function that switches the current Scene to the scene defined in [param path]
func go_to_scene(path):
	# call_deferred delays the function to execute after all other processes finish
	# this ensures that no code from the current scene is still being executed
	_deferred_go_to_scene.call_deferred(path)

## private function that does the actual scene switching
## Call only using call_deferred
func _deferred_go_to_scene(path):
	# At this point all code from the current scene has finished running
	current_scene.free() # remove the current scene from tree

	# load new scene
	var next_scene = ResourceLoader.load(path)

	 # instancietes next scene and set it to the current_scene variable
	current_scene = next_scene.instantiate()

	# add the new scene to the active scene tree as a child
	get_tree().root.add_child(current_scene)

## function to switch scenes to an already loaded packed scene passed in as [param scene]
## should be called with call_deferred
func go_to_preloaded_scene(preloaded_scene):
	# At this point all code from the current scene has finished running
	current_scene.free() # remove the current scene from tree

	 # instancietes the preloaded scene and set it to the current_scene variable
	current_scene = preloaded_scene.instantiate()

	# add the new scene to the active scene tree as a child
	get_tree().root.add_child(current_scene)

## function to switch the current scene to the scene with path [param path] but uses a loading screen
## between scene changes
func go_to_scene_with_loading(path):
	# call_deferred delays the function to execute after all other processes finish
	# this ensures that no code from the current scene is still being executed
	_deferred_go_to_scene_with_loading.call_deferred(path)

## Private function that does the actual scene switching with a loading screen
## Call only using call_deferred
func _deferred_go_to_scene_with_loading(path):
	# At this point all code from the current scene has finished running
	current_scene.free() # remove the current scene from tree

	# load new scene
	var loading_scene = ResourceLoader.load("res://scenes/loading_screen.tscn")

	 # instancietes next scene and set it to the current_scene variable
	current_scene = loading_scene.instantiate()

	# set the scene path that should be preloaded
	current_scene.scene_to_load = path

	# add the loading scene to the active scene tree as a child
	get_tree().root.add_child(current_scene)
