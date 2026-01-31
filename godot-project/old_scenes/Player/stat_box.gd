class_name StatBox

extends Control

@onready var stat_background = $StatBoxBackground
@onready var stat_name_label = $StatBoxBackground/StatNameLabel
@onready var stat_desc_label = $StatBoxBackground/StatDescLabel

func _ready() -> void:
	set_stat_box(Enums.Stats.VITALITY)
	print(Enums.Stats.FIRE_RATE)
	pass

func set_stat_box(stat:Enums.Stats) -> void:
	match stat:
		Enums.Stats.FIRE_RATE:
			stat_background.texture.region= Rect2(100,100,100,100) # Red
			stat_name_label.text = "Fire Rate"
			stat_desc_label.text = "Increase Fire Rate"
			pass
		Enums.Stats.SPEED:
			stat_background.texture.region = Rect2(0,400,100,100) # Yellow
			stat_name_label.text = "Speed"
			stat_desc_label.text = "Increase Movement Speed"
			pass
		Enums.Stats.DETECTION_RANGE:
			stat_background.texture.region = Rect2(200,100,100,100) # Blue
			stat_name_label.text = "Detection Range"
			stat_desc_label.text = "Increase Range for Detecting Enemies"
			pass
		Enums.Stats.VITALITY:
			stat_background.texture.region = Rect2(100,400,100,100) # Green
			stat_name_label.text = "Vitality"
			stat_desc_label.text = "Increase Max Health"
			pass
