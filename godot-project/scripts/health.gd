class_name Health
extends RefCounted

signal on_health_changed(current_health: int)
signal on_max_health_changed(max_health: int)
signal on_death


# current amount of health left
@export var current_health: int
# maximum amount of health attainable
@export var max_health: int
# temporary variable (make an args later on)
@export var default_health: int = 100


# Called when the object is created in memory for the first time
func _init(n: int) -> void:
	default_health = n
	max_health = n
	current_health = max_health


# returns current health value
func get_current_health() -> int:
	return current_health


# returns maximum health value
func get_max_health() -> int:
	return max_health


# returns wether or not object is dead. True if dead, False otherwise
func is_dead() -> bool:
	return current_health == 0


# decrease object health by n points
func take_damage(n: int) -> void:
	current_health = clamp((current_health - n), 0, max_health) # can't reduce health below 0
	on_health_changed.emit(current_health) # emit a signal when health is reduced

	# if object is dead, emit signal
	if current_health == 0:
		on_death.emit()


# increase object health by n points
func heal(n: int) -> void:
	current_health = clamp((current_health + n), 0, max_health) # can't increse health above max_health
	on_health_changed.emit(current_health) # emit a signal when health is increased


# decrease object maximum health by n points
func decrease_max_health(n: int) -> void:
	max_health = clamp((max_health - n), 0, max_health) # can't decrease max_health below 0
	on_max_health_changed.emit(max_health) # emit a signal when max_health is decreased

	# update current_health if it was formerly greater than current max_health
	if current_health > max_health:
		current_health = max_health

	# if object is dead, emit signal
	if max_health == 0:
		on_death.emit()


# increase obejct maximum health by n points
func increase_max_health(n: int) -> void:
	max_health = max_health + n
	on_max_health_changed.emit(max_health) # emit a signal when max_health is increased
	heal(n)

func reset_heath() -> void:
	max_health = default_health
	current_health = max_health


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
