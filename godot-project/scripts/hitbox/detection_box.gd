####################################### INFO ####################################
## A script thats part of the Box family.
## Detection_box sets hard-coded values indicating the Y mask it scans for.
## Detection_box can be thought of as a HurtBox; an object capable of 
##	RECOGNIZING that it collided with something: the thing it collided with
##	will NEVER know that it collided with US because detection_box sets NO
##	Layer values ie its a boogyman that can't be identified thus can't be 
##	detected.
## To use any Box sub-type: add to scene tree, set the group as needed, and add
##	a collision shape as a child. 
## At run time the Box-type gets the group its part of (the one you set), and uses
##	that to set it's Layer and Mask properties as hard-coded.
class_name DetectionBox extends Box

func _init() -> void:
	pass


func _ready() -> void:
	# Doing a call deferred as it MAY assist with issues akin to what happened
	#	to sword. Ie no matter what, it's collision values weren't being set.
	#	Likely due to the timing of when _ready() is called in relation to when
	#	the node is added to the scene tree in Player.
	call_deferred("set_collision")

## Function for determining the type of collisions to set based on what group
## Box has been set to in the editor group panel.
##	CAUTION: NEVER use collision_layer & collision_mask. Doing so will fail to
##		set desired collisions.
##		Only use the setter methods().
func set_collision() -> void:
	collision_layer = 0
	collision_mask = 0
	self.area_entered.connect(self._on_area_entered)
# Godots Layers	     1   2   3   4   5   6   7   8
# Binary value 	    001 002 004 008 016 032 064 128
#| 1      \| Walls/Boundaries   |
#| 2     | Player             | = 2
#| 3     | Player Projectiles | = 4
#| 4     | Enemies            | = 8
#| 5     | Enemy Projectiles  |	= 16
#|-6-----| "drops" -----------| = 32
#|-7-----| "weapon"-----------| = 64

# Check which group I was set to, so I can set correct values.
	if self.get_parent().is_in_group("player") :
		# Player scans for:
		set_collision_mask_value(DROPS,true)
		set_collision_mask_value(ENEMY,true)

	elif self.get_parent().is_in_group("enemy") :
		# Enemy scan's for
		set_collision_mask_value(PLAYER_WEAPON,true)
		set_collision_mask_value(PLAYER_PROJECTILE,true)
		set_collision_mask_value(PLAYER, true)
		set_collision_mask_value(ENEMY, true)

	elif self.get_parent().is_in_group("drops") :
		# Drops scan for.
		set_collision_mask_value(PLAYER,true)

	elif self.get_parent().is_in_group("player_projectile") :
		# Play_projectile scans for:
		set_collision_mask_value(ENEMY,false)

	elif self.get_parent().is_in_group("player_weapon"):
		# Player_weapon scans for:
		set_collision_mask_value(ENEMY,true)

	else :
		push_warning("Caution : You've attach hurtbox to something that it doesn't
		have collision values defined for.", self.get_parent().get_parent())



## Custom code that gets called when a valid Box-type enters our collision-area.
## We receive the colliding Box object, which means we can access the owner its attached to.
func _on_area_entered(hitbox: Box ) -> void:
	## ERROR CHECK: If we somehow have a null Box, do nothing.
	if hitbox == null:
		push_warning("HIGH PRIORITY WARNING: Hit_Hurt_Box:_on_area_entered:
			hitbox == null. This should NOT be possible.")
		return

	# If my owner has a method called collision, call it. 
	if owner.has_method("collision") :
		owner.collision(hitbox)
	
	# Since each box receives a group at code-time and we have the 
	#	box we collided with, you could code in more complex logic
	#	that is centralized right here, avoiding cluttering the 
	# 	owner's script.
