extends Control # Or whatever your main node type is

# Get references to the nodes using @onready
@onready var text_label: Label = $Label
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer # You might use a Timer for timed pop-ups

var dialogue_lines = ["Once upon day when Nick, Harris, Duncan, and Vlod were out for a walk in the park when they stumbled across a party to which they were not invited, now furious at each other for leading them into this place of unwelcome, they overreacted a bit and Vlod fired a blunderbuss from his pocket barely missing his former friends, they found some spare masks worn by the party goers and put them on to hide, chaos then ensued."]
var current_line_index = 0

func _ready():
	# Connect the Timer timeout signal if using a timer for progression
	# $Timer.connect("timeout", show_next_text) 
	pass

# A function to show the text and play the audio
func show_text(text_to_display: String):
	text_label.text = text_to_display
	play_pop_sound()

func play_pop_sound():
	if audio_player.stream != null:
		audio_player.play()

# Example usage: Call this when an event happens (e.g., player enters area, button pressed)
func _input(event):
	if event.is_action_pressed("ui_accept"): # Example action
		if current_line_index < dialogue_lines.size():
			show_text(dialogue_lines[current_line_index])
			current_line_index += 1
		else:
			print("End of dialogue.")
