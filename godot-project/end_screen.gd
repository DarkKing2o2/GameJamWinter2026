extends Node2D

# Called when the node enters the scene tree for the first time.
var label

func _ready() -> void:
	pass # Replace with function body.
	#var player_1 = get_node("Player_0")
	#var player_2 = get_node("Player_1")
	
	#label = get_node("Label")
	#player_1.winning_player.connect(win("1"))
	#player_2.winning_player.connect(win("2"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func win(player_num):
	label.text = ("PLAYER" + player_num + " WINS!")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func _input(event) -> void:
	if event.is_action_pressed("Attack-GamePad0") || event.is_action_pressed("Attack-GamePad1"):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
