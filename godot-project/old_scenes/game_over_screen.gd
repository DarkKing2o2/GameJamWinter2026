extends CanvasLayer

var is_game_over = false

@onready var hover_sfx_player = $HoverSFX
@onready var click_sfx_player = $ClickSFX

func _ready():
	# Ensure the Game Over screen is hidden at the start

	visible = false

	# Connect button signals
	var restart_button = $Panel/restart
	var quit_button = $Panel/quit
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	# Add to group for easy access from other scripts
	add_to_group("game_over_screen")

## called when the player dies
func game_over():
	if not is_game_over:
		is_game_over = true
		get_tree().paused = true # Pause the game
		visible = true # Show the Game Over screen

# Restart the game
func _on_restart_pressed():
	click_sfx_player.play()
	get_tree().paused = false
	is_game_over = false
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("drops", "queue_free")

	#get_tree().reload_current_scene()
	visible = false
	SceneManager.go_to_scene_with_loading("res://scenes/level_1.tscn")

# Quit the game
func _on_quit_pressed():
	click_sfx_player.play()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("drops", "queue_free")

	get_tree().paused = false
	is_game_over = false
	visible = false
	SceneManager.go_to_scene_with_loading("res://scenes/title_menu.tscn")

## Function that executes when ANY buttons are hovered over
func _on_button_hover() -> void:
	hover_sfx_player.play()
