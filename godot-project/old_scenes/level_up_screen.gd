extends NinePatchRect

class_name LevelUpScreen

@export var player: CharacterBody2D
var _points_allotted: int = 0

func _ready():
	self.visible = false
	#player.player_stats.player_leveled_up.connect(_on_player_level_up)
	#player.player_stats.player_stats_changed.connect(_on_player_stats_updated)

	#connect buttons
	$"VBoxContainer/LevelUpScreenRow1/PlusButton".pressed.connect(_on_speed_up_button)
	$"VBoxContainer/LevelUpScreenRow1/MinusButton".pressed.connect(_on_speed_down_button)
	$"VBoxContainer/LevelUpScreenRow2/PlusButton".pressed.connect(_on_fire_rate_up_button)
	$"VBoxContainer/LevelUpScreenRow2/MinusButton".pressed.connect(_on_fire_rate_down_button)
	$"VBoxContainer/LevelUpScreenRow3/PlusButton".pressed.connect(_on_detection_range_up_button)
	$"VBoxContainer/LevelUpScreenRow3/MinusButton".pressed.connect(_on_detection_range_down_button)
	$"VBoxContainer/LevelUpScreenRow4/PlusButton".pressed.connect(_on_vitatility_up_button)
	$"VBoxContainer/LevelUpScreenRow4/MinusButton".pressed.connect(_on_vitatility_down_button)
	$"SaveButton".pressed.connect(_on_save_button)


func _on_player_level_up(new_level: int, points_to_give: int):
	get_tree().paused = true
	self.visible = true
	_points_allotted = points_to_give
	$"RemainingPointsValueLabel".text = str(_points_allotted)
	$"VBoxContainer/LevelUpScreenRow1/PointChangeLabel".text = "0"
	$"VBoxContainer/LevelUpScreenRow2/PointChangeLabel".text = "0"
	$"VBoxContainer/LevelUpScreenRow3/PointChangeLabel".text = "0"
	$"VBoxContainer/LevelUpScreenRow4/PointChangeLabel".text = "0"


func _on_player_stats_updated(new_stats: Dictionary):
	var row: HBoxContainer = $"VBoxContainer/LevelUpScreenRow1"
	var stat_name_label: Label = row.get_node("StatNameLabel")
	var current_points_label: Label = row.get_node("CurrentPointsLabel")
	stat_name_label.text = "Speed"
	current_points_label.text = str(new_stats["current_movement_speed"])

	row = $"VBoxContainer/LevelUpScreenRow2"
	stat_name_label = row.get_node("StatNameLabel")
	current_points_label = row.get_node("CurrentPointsLabel")
	stat_name_label.text = "Fire Rate"
	current_points_label.text = str(new_stats["current_fire_rate"])

	row = $"VBoxContainer/LevelUpScreenRow3"
	stat_name_label = row.get_node("StatNameLabel")
	stat_name_label.text = "Detection Range"
	current_points_label = row.get_node("CurrentPointsLabel")
	current_points_label.text = str(new_stats["current_detection_range"])

	row = $"VBoxContainer/LevelUpScreenRow4"
	stat_name_label = row.get_node("StatNameLabel")
	stat_name_label.text = "Vitatility"
	current_points_label = row.get_node("CurrentPointsLabel")
	current_points_label.text = str(new_stats["current_max_health"])

func _on_save_button():
	player.player_stats.current_movement_speed_points += int($"VBoxContainer/LevelUpScreenRow1/PointChangeLabel".text)
	player.player_stats.current_fire_rate_points += int($"VBoxContainer/LevelUpScreenRow2/PointChangeLabel".text)
	player.player_stats.current_detection_range_points += int($"VBoxContainer/LevelUpScreenRow3/PointChangeLabel".text)
	player.player_stats.current_max_health_points += int($"VBoxContainer/LevelUpScreenRow4/PointChangeLabel".text)
	self.visible = false
	get_tree().paused = false

func _update_point_change_label(label: Label, change: int):
	var remaining_points_label: Label = $"RemainingPointsValueLabel"
	var remaining_points = int(remaining_points_label.text)
	var cur_value = int(label.text)

	if change > 0 and remaining_points <= 0:
		return
	if change < 0 and cur_value <= 0:
		return

	var new_value = cur_value + change
	new_value = max(0, new_value)
	label.text = "%+d" % new_value if new_value != 0 else "0"

	remaining_points -= change
	remaining_points = clamp(remaining_points, 0, _points_allotted)
	remaining_points_label.text = str(remaining_points)


func _on_speed_up_button():
	var label = $"VBoxContainer/LevelUpScreenRow1/PointChangeLabel"
	_update_point_change_label(label, 1)

func _on_speed_down_button():
	var label = $"VBoxContainer/LevelUpScreenRow1/PointChangeLabel"
	_update_point_change_label(label, -1)

func _on_fire_rate_up_button():
	var label = $"VBoxContainer/LevelUpScreenRow2/PointChangeLabel"
	_update_point_change_label(label, 1)

func _on_fire_rate_down_button():
	var label = $"VBoxContainer/LevelUpScreenRow2/PointChangeLabel"
	_update_point_change_label(label, -1)

func _on_detection_range_up_button():
	var label = $"VBoxContainer/LevelUpScreenRow3/PointChangeLabel"
	_update_point_change_label(label, 1)

func _on_detection_range_down_button():
	var label = $"VBoxContainer/LevelUpScreenRow3/PointChangeLabel"
	_update_point_change_label(label, -1)

func _on_vitatility_up_button():
	var label = $"VBoxContainer/LevelUpScreenRow4/PointChangeLabel"
	_update_point_change_label(label, 1)

func _on_vitatility_down_button():
	var label = $"VBoxContainer/LevelUpScreenRow4/PointChangeLabel"
	_update_point_change_label(label, -1)
