## Tool keyword added for _generate_name()
@tool

extends BTAction
## Attacks player, returning [code]SUCCESS[/code]. If player was hit. [br]
## Returns [code]FAILURE[/code] if [agent] if player was not hit.
## Uses blackboard var target which comes from agents internal target var.

## Store a local reference to the blackboard vars to save resources.
var _target = "target"
var _attack = "attack"
var target
var attack

# Display a customized name (requires @tool).
func _generate_name() -> String:
	# Should print "Is <TargetName> in range?"
	return "Attack target with melee attack"

func _setup() -> void:
	self.target = blackboard.get_var(self._target)
	self.attack = blackboard.get_var(self._attack)


## Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	# Update target var just in case.
	target = blackboard.get_var(self._target)
	# Check if it exists. If not, we can switch routine to something else vs
	#	outright crashing.
	if not is_instance_valid(target):
		breakpoint
		return FAILURE

	# Do the attack
	self.attack.do_Attack()
	return SUCCESS
