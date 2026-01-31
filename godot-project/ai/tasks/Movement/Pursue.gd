## Tool keyword added for _generate_name()
@tool


extends BTAction
## Move towards the target while not at desired postition or script is allowed to continue.  [br]
## Returns [code]RUNNING[/code] while moving towards the target but not yet at the desired position. [br]
## Returns [code]SUCCESS[/code] when at the desired position relative to the target. [br]
## Returns [code]FAILURE[/code] if we cannot reach the target for some reason.[br]

## Store a local reference to the blackboard vars to save resources.
var _target = "target"
var _spotRange = "spotRange"
var _attackRange = "attackRange"
var target
var spotRange
var attackRange

func _setup() -> void:
	self.target = blackboard.get_var(self._target)
	self.spotRange = blackboard.get_var(self._spotRange)
	self.attackRange = blackboard.get_var(self._attackRange)



# Display a customized name (requires @tool).
func _generate_name() -> String:
	# Should print "Is <TargetName> in range?"
	return "Purse target until in attack range."


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	target = blackboard.get_var(self._target)
	if not is_instance_valid(target):
		return FAILURE

	# If distance to target is less than the agents attack range, we've successfully
	#	pursed the target.
	var desired_pos: Vector2 = target.global_position
	if agent.global_position.distance_to(desired_pos) < attackRange: return SUCCESS

	#print_debug()
	#print("True dist to player: ", agent.global_position.distance_to(desired_pos) )
	# Get the vector from agent to target = target-> minus agent->
	var directionToMoveIn : Vector2 = ( self.target.global_position - self.agent.global_position).normalized()
	agent.move(directionToMoveIn )
	return RUNNING
