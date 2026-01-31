class_name OptionsMenu

extends CanvasLayer

## Signal to tell the parent of the options menu to hide the options menu
signal close_options_menu

@onready var master_slider = $OptionsMenu/VBoxContainer/MasterSlider
@onready var master_label = $OptionsMenu/VBoxContainer/MasterLabels/MasterValue
@onready var music_slider = $OptionsMenu/VBoxContainer/MusicSlider
@onready var music_label = $OptionsMenu/VBoxContainer/MusicLabels/MusicValue
@onready var sfx_slider = $OptionsMenu/VBoxContainer/SFXSlider
@onready var sfx_label = $OptionsMenu/VBoxContainer/SFXLabels/SFXValue
@onready var mute_box = $OptionsMenu/VBoxContainer/Mute

@onready var hover_sfx_player = $HoverSFX
@onready var click_sfx_player = $ClickSFX
@onready var close_sfx_player = $CloseSFX
@onready var xp_pickup_sfx = $XPPickupSFX


func _ready() -> void:
	master_slider.value = MusicManager.master_volume
	master_label.text = str(roundi(MusicManager.master_volume * 100)) + "%"
	music_slider.value = MusicManager.music_volume
	music_label.text = str(roundi(MusicManager.music_volume * 100)) + "%"
	sfx_slider.value = MusicManager.sfx_volume
	sfx_label.text = str(roundi(MusicManager.sfx_volume * 100)) + "%"
	mute_box.button_pressed = MusicManager.mute
	#MusicManager.background_music.play() # for testing


func _on_master_slider_value_changed(value: float) -> void:
	master_label.text = str(roundi(master_slider.value * 100)) + "%"
	MusicManager.master_volume = master_slider.value


func _on_music_slider_value_changed(value: float) -> void:
	music_label.text = str(roundi(music_slider.value * 100)) + "%"
	MusicManager.music_volume = music_slider.value


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_label.text = str(roundi(sfx_slider.value * 100)) + "%"
	MusicManager.sfx_volume = sfx_slider.value


func _on_mute_toggled(toggled_on: bool) -> void:
	MusicManager.mute = toggled_on
	click_sfx_player.play()

func _on_close_button_pressed() -> void:
	close_options_menu.emit()

## Function that executes when ANY buttons are hovered over
func _on_button_hover() -> void:
	hover_sfx_player.play()


func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	play_xp_pickup_sfx()

func play_xp_pickup_sfx() -> void:
	#xp_pickup_sfx.pitch_scale = randf_range(0.9,1.1)
	xp_pickup_sfx.play()
