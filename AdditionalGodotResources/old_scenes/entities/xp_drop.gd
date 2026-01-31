class_name XPDrop

extends Area2D
## XP Drop script attached to XP Drop scene

## variable that determines how much xp will be given when collected
var xp_to_give:int = 1

# Commented out since player hitbox is area not a body
#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"): #If player touches this
		#if body.has_method("on_xp_pickup"):
			#body.on_xp_pickup()
			#queue_free() #remove xp drop
		##else:
			##print_debug("player but not function am: ", body, " parent: ", body.get_parent() )

## When an Area2D enters the same space as the XPDrop, if the area2d is a hit box of the player
## increase player xp by xp_to_give
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"): #If player touches this
		if area.get_parent().has_method("on_xp_pickup"):
			area.get_parent().on_xp_pickup(xp_to_give)
			queue_free() #remove xp drop
		#else:
			#print_debug("player but not function am: ", area, " parent: ", area.get_parent() )
