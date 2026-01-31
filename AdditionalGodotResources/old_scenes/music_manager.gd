extends Node

## variable that controls main_menu_music player
@onready var menu_music = $MainMenuMusic
## variable that controls background_music player
@onready var background_music = $BackgroundMusic
## variable that controls the Enemy Hurt SFX
## This is in Music manager so that there arent too many instances of the SFX playing
@onready var enemy_hurt_sfx = $EnemyHurtSFX
## Variable that tracks the current song being played 
var current_track: AudioStreamPlayer

## variable that controls if all audio is muted or not
@export var mute:bool = false:
	set(value):
		mute=value
		AudioServer.set_bus_mute(0,mute)

## variable that controls the volume of Audio Bus Master using linear audio [br]
## Changing the variable also sets the volume for the Master Audio Bus
@onready var master_volume:float = AudioServer.get_bus_volume_linear(0):
	set(new_volume):
		master_volume=new_volume
		AudioServer.set_bus_volume_linear(0,new_volume)

## variable that controls the volume of Audio Bus 1_Music using linear audio [br]
## Changing the variable also sets the volume for the 1_Music Audio Bus
@onready var music_volume:float = AudioServer.get_bus_volume_linear(1):
	set(new_volume):
		music_volume = new_volume
		AudioServer.set_bus_volume_linear(1,new_volume)

## variable that controls the volume of Audio Bus 2_SFX using linear audio [br]
## Changing the variable also sets the volume for the 2_SFX Audio Bus
@onready var sfx_volume:float = AudioServer.get_bus_volume_linear(2):
	set(new_volume):
		sfx_volume = new_volume
		AudioServer.set_bus_volume_linear(2,new_volume)

## This function will stop all music tracks currently playing
func stop_music() -> void:
	current_track.stop()

## This function will stop all music tracks from playing and play the passed in track [br]
## if the track is already playing, it will not reset the track
func play_track(track: AudioStreamPlayer)-> void:
	if current_track == track:
		return
	if current_track:
		current_track.stop()
	current_track = track
	current_track.play()

## This function will restart the current track from the beginning
func reset_track() -> void:
	current_track.play()

## This function will play the Enemy hurt sfx
func enemy_hurt() -> void:
	enemy_hurt_sfx.play()
