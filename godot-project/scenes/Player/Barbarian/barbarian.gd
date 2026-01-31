extends Node3D

@onready var hsm: LimboHSM = $LimboHSM
@onready var idle_state: LimboState = $LimboHSM/IdleState
@onready var move_state: LimboState = $LimboHSM/MoveState

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _init_state_machine() -> void:
	hsm.add_transition(idle_state, move_state, idle_state.EVENT_FINISHED)
	hsm.add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	hsm.add_transition()
