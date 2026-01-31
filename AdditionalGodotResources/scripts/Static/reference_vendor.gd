@icon("res://assets/Script_Icons/scripts/static_scrip_icon.jpg")

## Singleton pattern for storing references to important objects.
class_name ReferenceVendor extends Node

signal REFERENCE_VENDOR_NOTIFICATION_SIGNAL( requestedInstanceRef: Object )

## Var for maintaining a main subscriber list. Anytime a new subscriber appears,
##	they'll be added, and if the player reference exists, the subscriber will
##	receive a notification with the reference. Internal array holds the caller
##	and the requested call back.
var _subscriberList : Array[Array]
## Var for the subscribers whom have received a notification.
var _closedList : Array
## Var for the subscribers whom have NOT received a notification.
var _openList : Array


enum _INFO {
	SUBSCRIBER = 0,
	REQUESTED_INSTANCE = 1,
}


enum ID {
	PLAYER = 0,
}

## Attribute for storing references to objects.
var _references : Dictionary = {}

## Function() for registering a caller with ReferenceVendor. Must be a supported
##	enum from the ID list IE only player can add themselves rn.
func Register(object : Object , reference_enum : ID ) -> void:
	if reference_enum not in ID.values() :
		print_debug()
		print(reference_enum , " " , ID)
		push_warning("Supplied enum not found in ReferenceVendors registerAs enum
			list. Nothing done.")
		breakpoint
		return

	# Else, register.
	_references[reference_enum] = object
	_references.get_or_add(reference_enum, object)
	return

## Function() for getting the reference given the enum.
## Returns:
##	object : A reference to the player instance if it exists. Race condition possible.
##	STATUS.FAILED :	To indicate that doesn't exist at the moment.
func Obtain( reference_enum : ID ) -> Object:
	if reference_enum not in ID.values():
		print_debug()
		push_warning("Supplied enum not found in ReferenceVendors Obtain enum
			list. Nothing done.")
		breakpoint
		return

	return _references.get(reference_enum)



## Function() that allows a caller to subscribe itself to receive notification
##	when the player instance is added. Requires only a listener method in the
##	caller.
## Reason is to avoid a race condition or repeated inquires from the caller. The
##	ref vendor takes over the role of tracking and notifying subscribers.
## Requires caller to implement a method called:
##	REFERENCE_VENDOR_NOTIFICATION_LISTENER()
## Which will be called by Reference Vendor once it possess the request instance
##	reference. Not a literal signal listener, rather a 'imitation', used as a
##	method call to attain individuality but listener methadology just makes
##	it simpler.
func SubscribeToNotification( caller : Object, desiredReference : ID ) -> void:
	if not caller.has_method("reference_vendor_notification_listener"):
		print_debug()
		push_warning("You do not have the required method implemented to
			receive notification. Taking no action, nothing done.")
		breakpoint
		return
	elif desiredReference not in ID.values():
		print_debug()
		push_warning("Requested reference does not exist in ReferenceVendor's ID
			list. Nothing done.")
		breakpoint
		return

	# Else, add as subscriber:
	var newSub = [caller, desiredReference]
	self._subscriberList.append(newSub)
	# Add to openList
	self._openList.append(newSub)
	# Call function() that checks if the reference exists.
	_check_Reference_Exists()
	return

## -Function() for checking if the reference has been added to our list. Checks
##	the last index in the openlist and if that sub's requested instance exists
##	then it notifys the sub, removes sub from openlist, and calls itself again.
## NOTE: This recursive way works so long as there's only ever one unique ID
##	reference. Why? Because otherwise the last sub in _openList can become a
##	plug for the rest, where until the last sub's requestedInstance has been
##	registered with us, no this function will not check any of the other subs
##	in the openlist who are also waiting for a notification. For loop fixes this.
func _check_Reference_Exists() -> void:
	var openListSize = self._openList.size()
	# Success Case: If everyone has received a notification, then don't call
	#	this again.
	if openListSize == 0:
		return

	# Edge case 1: The requested instance exists, make call back.
	elif (self._openList[openListSize - 1])[_INFO.REQUESTED_INSTANCE] in ID.values() :
		# Get this sub and remove it from openlist
		var sub = self._openList.pop_back()
		# Call
		self._notify(sub)
		# Add it to the closed list:
		self._closedList.append( sub )
		# Now call this function again by exiting out of this if chain.

	# Default case: Requested instance doesn't exist, call check back later.
	await get_tree().create_timer(1).timeout.connect(_check_Reference_Exists)

	return


## -Function() for making notification:
func _notify(sub : Array) -> void:
	# Var for the reference
	var requestedRef = self.Obtain(sub[_INFO.REQUESTED_INSTANCE])
	# Call the sub
	sub[_INFO.SUBSCRIBER].reference_vendor_notification_listener(requestedRef)
	return
