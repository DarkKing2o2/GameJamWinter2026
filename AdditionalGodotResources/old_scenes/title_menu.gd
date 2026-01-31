class_name TitleMenu

extends Control

@onready var options_menu = $OptionsMenuLayer
## The shader that plurs the background in the options menu, will be hiding for only title screen
@onready var options_background_blur = options_menu.get_node("BackgroundBlur")
## Array of nodes that need to be hidden when options menu is openned
@onready var to_hide_on_options = get_tree().get_nodes_in_group("hide_on_options")
##
@onready var hover_sfx_player = $HoverSFX
@onready var click_sfx_player = $ClickSFX
@onready var close_sfx_player = $CloseSFX

func _ready() -> void:
	options_menu.hide()
	options_menu.close_options_menu.connect(_on_options_menu_close_button_pressed)
	MusicManager.play_track(MusicManager.menu_music)

func _on_play_game_button_pressed() -> void:
	SceneManager.go_to_scene_with_loading("res://scenes/level_1.tscn") # When level created this will go to that scene
	click_sfx_player.play()
	MusicManager.play_track(MusicManager.background_music)


func _on_options_button_pressed() -> void:
	click_sfx_player.play()
	options_menu.show()
	options_background_blur.hide()
	for i in to_hide_on_options:
		i.hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_options_menu_close_button_pressed() -> void:
	close_sfx_player.play()
	options_menu.hide()
	options_background_blur.show()
	for i in to_hide_on_options:
		i.show()

## Function that executes when ANY buttons are hovered over
func _on_button_hover() -> void:
	hover_sfx_player.play()
