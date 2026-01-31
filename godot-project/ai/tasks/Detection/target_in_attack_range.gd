## Tool keyword added for _generate_name()
@tool

extends BTCondition
## Checks if agent is in attack range of target, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if [agent] is not within [member target] range.
## Uses blackboard var target which comes from agents internal target var.

## Store a local reference to the blackboard vars to save resources.
var _target = "target"
var _attackRange = "attackRange"
var target
var attackRange

# Display a customized name (requires @tool).
func _generate_name() -> String:
	# Should print "Is <TargetName> in range?"
	return "Is target within attacking range?"

func _setup() -> void:
	self.target = blackboard.get_var(self._target)
	self.attackRange = blackboard.get_var(self._attackRange)


## Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	# Update target var just in case.
	target = blackboard.get_var(self._target)
	# Check if it exists. If not, we can switch routine to something else vs
	#	outright crashing.
	if not is_instance_valid(target):
		breakpoint
		return FAILURE

	# Since all is valid, check that we are within the attack range
	#	distance to the target.
	# Calculate the distance from us to the target.
	# TODO: refactor to call agents spot_range var when we create it.
	var distance : float = target.global_position.x - agent.global_position.x
	if distance < attackRange :
		return SUCCESS
	else : return FAILURE
