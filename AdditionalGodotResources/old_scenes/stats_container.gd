extends GridContainer

@onready var player =$"../../../Player"
func _ready():
	player.player_stats.player_stats_changed.connect(update_player_stats)
	player.player_stats.emit_player_stats_changed_signal()

func update_player_stats(new_stats:Dictionary):
	$LevelValue.set_text(str(new_stats["current_level"]))
	$ExperienceValue.set_text(
		str(new_stats["current_experience"]) + " / " +
		str(new_stats["experience_to_level_up"])
		)
	$MovementSpeedValue.set_text(str(new_stats["current_movement_speed"]))
	$FireRateValue.set_text(str(new_stats["current_fire_rate"]))
	$DetectionRangeValue.set_text(str(new_stats["current_detection_range"]))
	$VitalityValue.set_text(str(new_stats["current_max_health"]))
