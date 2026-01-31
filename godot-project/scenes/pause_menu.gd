class_name PauseMenu

extends CanvasLayer

@onready var options_menu_layer = $OptionsMenuLayer
@onready var hover_sfx_player = $HoverSFX
@onready var click_sfx_player = $ClickSFX
@onready var close_sfx_player = $CloseSFX

func _ready() -> void:
	self.hide() # This is to make sure on levels that the pause menu does not show immediately
	options_menu_layer.hide()
	options_menu_layer.close_options_menu.connect(_on_options_menu_close_button_pressed)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		#if pause button pressed and the game is not paused, pause the game
		pause_game()
	elif Input.is_action_just_pressed("pause") and get_tree().paused and not options_menu_layer.visible:
		#if pause button pressed and the game is already paused, and options menu is not visible
		resume_game()

func resume_game():
	get_tree().paused = false
	self.hide()
	close_sfx_player.play()

func pause_game():
	get_tree().paused = true
	self.show()
	click_sfx_player.play()

func _on_resume_pressed() -> void:
	resume_game()

func _on_quit_title_screen_pressed() -> void:
	click_sfx_player.play()
	resume_game()
	get_tree().call_group("drops", "queue_free")
	SceneManager.go_to_scene("res://scenes/title_menu.tscn")


func _on_quit_game_pressed() -> void:
	click_sfx_player.play()
	get_tree().quit()


func _on_options_pressed() -> void:
	click_sfx_player.play()
	self.hide()
	options_menu_layer.show()

func _on_options_menu_close_button_pressed() -> void:
	close_sfx_player.play()
	options_menu_layer.hide()
	self.show()

## Function that executes when ANY buttons are hovered over
func _on_button_hover() -> void:
	hover_sfx_player.play()
