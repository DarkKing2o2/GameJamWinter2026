extends NinePatchRect

@onready var left_stat_box : StatBox = $StatBoxLeft
@onready var right_stat_box : StatBox = $StatBoxRight
@onready var player:player_lightning_wizard = $"../.."

var left_stat:Enums.Stats
var right_stat:Enums.Stats

func _ready() -> void:
	player.player_stats.player_leveled_up.connect(_on_player_level_up)

func _on_player_level_up(new_level: int, points_to_give: int):
	get_tree().paused = true
	self.visible=true
	#var left_stat_key = randi_range(0,Enums.Stats.size()-1) #0 - 3
	#var right_stat_key = randi_range(0, Enums.Stats.size()-2) # 0- 2
	left_stat = randi_range(0,Enums.Stats.size()-1) as Enums.Stats #0 - 3
	right_stat = randi_range(0, Enums.Stats.size()-2) as Enums.Stats # 0- 2
	# since right rng is one less to ensure that all other stats are available, if right stat it
	# equal to or greater than left stat it increases by 1, this makes sure that all other
	# possibilities are possible without repeats
	#if (right_stat_key >= left_stat_key):
		#right_stat_key += 1
	if (right_stat >= left_stat):
		right_stat += 1
	#left_stat = Enums.Stats.find_key(left_stat_key)
	#right_stat = Enums.Stats.find_key(right_stat_key)
	left_stat_box.set_stat_box(left_stat as Enums.Stats)
	right_stat_box.set_stat_box(right_stat as Enums.Stats)


func _on_left_stat_button_pressed() -> void:
	update_player_stat(left_stat)
	get_tree().paused = false
	self.visible = false


func _on_right_stat_button_pressed() -> void:
	update_player_stat(right_stat)
	get_tree().paused = false
	self.visible = false

func update_player_stat(stat:Enums.Stats) -> void:
	match stat:
		Enums.Stats.FIRE_RATE:
			player.player_stats.current_fire_rate_points += 1
			pass
		Enums.Stats.SPEED:
			player.player_stats.current_movement_speed_points += 1
			pass
		Enums.Stats.DETECTION_RANGE:
			player.player_stats.current_detection_range_points += 1
			pass
		Enums.Stats.VITALITY:
			player.player_stats.current_max_health_points += 1
			pass
