## Class for the player's stats. 

extends RefCounted

class_name PlayerStats

const MOVEMENT_SPEED_MIN = 100
const MOVEMENT_SPEED_MAX = 300
const MOVEMENT_SPEED_STEP = 10

const FIRE_RATE_MIN = 1.0
const FIRE_RATE_MAX = 3.0
const FIRE_RATE_STEP = 0.1

const DETECTION_RANGE_MIN = 400
const DETECTION_RANGE_MAX = 1000
const DETECTION_RANGE_STEP = 50

const MAX_HEALTH_MIN = 30
const MAX_HEALTH_MAX = 200
const MAX_HEALTH_STEP = 10

# For f(x) = Ae^(kx) A defines the starting point when x = 0
const EXP_A = 2

# For f(x) = Ae^(kx) k is the growth rate of the function
const EXP_K = 0.2


## Number of stat points in player movement speed
var current_movement_speed_points: int = 0:
	get:
		return current_movement_speed_points
	set(value):
		current_movement_speed_points = value
		emit_player_stats_changed_signal()

## Number of stat points in player weapon fire rate
var current_fire_rate_points: int = 0:
	get:
		return current_fire_rate_points
	set(value):
		current_fire_rate_points = value
		emit_player_stats_changed_signal()

## Number of stat points in player's enemy detection range
var current_detection_range_points: int = 5:
	get:
		return current_detection_range_points
	set(value):
		current_detection_range_points = value
		emit_player_stats_changed_signal()

## Number of stat points in max health
var current_max_health_points: int = 0:
	get:
		return current_max_health_points
	set(value):
		current_max_health_points = value
		emit_player_stats_changed_signal()

## Movement speed is a list of speeds between [constant MOVEMENT_SPEED_MIN] and
## [constant MOVEMENT_SPEED_MAX] inclusive.
## A flat [constant MOVEMENT_SPEED_STEP] speed is added per [member current_movement_speed_points]
var current_movement_speed: float:
	get:
		return clamp(
			100 + 10 * current_movement_speed_points,
			MOVEMENT_SPEED_MIN,
			MOVEMENT_SPEED_MAX
		)

## Movement speed is a list of speeds between [constant FIRE_RATE_MIN] and
## [constant FIRE_RATE_MAX] inclusive.
## A flat [constant FIRE_RATE_STEP] speed is added per [member current_fire_rate_points]
var current_fire_rate: float:
	get:
		return clamp(
			FIRE_RATE_MIN + FIRE_RATE_STEP * current_fire_rate_points,
			FIRE_RATE_MIN,
			FIRE_RATE_MAX
		)


## Movement speed is a list of speeds between [constant DETECTION_RANGE_MIN] and
## [constant DETECTION_RANGE_MAX] inclusive.
## A flat [constant DETECTION_RANGE_STEP] speed is added per [member current_detection_range_points]
var current_detection_range: float:
	get:
		return clamp(
			DETECTION_RANGE_MIN + DETECTION_RANGE_STEP * current_detection_range_points,
			DETECTION_RANGE_MIN,
			DETECTION_RANGE_MAX
		)


## Movement speed is a list of speeds between [constant MAX_HEALTH_MIN] and
## [constant MAX_HEALTH_MAX] inclusive.
## A flat [constant MAX_HEALTH_STEP] speed is added per [member current_max_health_points]
var current_max_health: float:
	get:
		return clamp(
			MAX_HEALTH_MIN + MAX_HEALTH_STEP * current_max_health_points,
			MAX_HEALTH_MIN,
			MAX_HEALTH_MAX
		)


var current_level: int = 1:
	get:
		return current_level
	set(value):
		var old_level = current_level
		current_level = value
		if old_level != current_level:
			emit_player_stats_changed_signal()
			player_leveled_up.emit(current_level, 2)

var current_experience: int = 0:
	get:
		return current_experience
	set(value):
		current_experience = value
		emit_player_stats_changed_signal()

## Calculates the experience needed to level up from the
## current level to the next level using an exponential function
var experience_to_level_up: int:
	# General form of the exponential function is f(x) = Ae^(kx)
	# where A is the y intercept and k is the growth rate
	get:
		return round(EXP_A * exp(EXP_K * current_level))


signal player_leveled_up(new_level: int, points_to_give)
signal player_stats_changed(new_stats: Dictionary)

func emit_player_stats_changed_signal():
	var new_stats = {
		"current_level": current_level,
		"current_experience": current_experience,
		"experience_to_level_up": experience_to_level_up,
		"current_movement_speed": current_movement_speed_points,
		"current_fire_rate": current_fire_rate_points,
		"current_detection_range": current_detection_range_points,
		"current_max_health": current_max_health_points,

	}
	player_stats_changed.emit(new_stats)


func add_experience(xp: int):
	current_experience += xp
	while current_experience >= experience_to_level_up:
		current_experience -= experience_to_level_up
		current_level += 1
