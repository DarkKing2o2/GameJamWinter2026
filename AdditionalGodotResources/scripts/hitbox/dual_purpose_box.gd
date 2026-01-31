####################################### INFO ####################################
## A script thats part of the Box family.
## DualPurposeBox sets hard-coded values indicating the X layer something is on
##	and the Y mask it scans for.
## DualPurposeBox can be thought of as a HitHurtBox; an object capable of 
##	RECOGNIZING that it collided with some other X Layer and that it 
##	is part of the X Layer group and can be detected on that X Layer by 
##	anything scanning for the equivalent Y Mask value. 
## To use any Box sub-type: add to scene tree, set the group as needed, and add
##	a collision shape as a child. 
## At run time the Box-type gets the group its part of (the one you set), and uses
##	that to set it's Layer and Mask properties as hard-coded.
class_name DualPurposeBox extends Box

func _init() -> void:
	pass

func _ready() -> void:
	# Doing a call deferred. Previously because race-conditions arose during
	#	attempts to automate creation of entire Box structure; this box, a child of 
	#	some parent, gets loaded in first (as per godots convention and engine),
	#	and attempts to get some information from the parent who has yet to be loaded in.
	# The solution, was NOT to be lazy and try automating this.
	call_deferred("set_collision")


## Function for determining the type of collisions to set based on what group
## Box has been set to in the editor group panel.
##	CAUTION: NEVER use collision_layer & collision_mask. Doing so will fail to
##		set desired collisions.
##		Only use the setter methods().
func set_collision() -> void:
	collision_layer = 0
	collision_mask = 0
	damage = 1
	self.area_entered.connect(self._on_area_entered)
# Godots Layer		 1   2   3   4   5   6   7   8
# Binary value 	    001 002 004 008 016 032 064 128
#| 1      \| Walls/Boundaries   |
#| 2     | Player             | = 2
#| 3     | Player Projectiles | = 4
#| 4     | Enemies            | = 8
#| 5     | Enemy Projectiles  |	= 16
#|-6-----| "drops" -----------| = 32
#|-7-----| "weapon"-----------| = 64
	if self.is_in_group("player") :
		# Player found on:
		set_collision_layer_value(PLAYER, true)
		# Player scans for:
		set_collision_mask_value(DROPS,true)
		set_collision_mask_value(ENEMY,true)

	elif self.is_in_group("enemy") :
		# Enemy found on:
		set_collision_layer_value(ENEMY, true)
		# Enemy scan's for
		set_collision_mask_value(PLAYER_WEAPON,true)
		set_collision_mask_value(PLAYER_PROJECTILE,true)
		set_collision_mask_value(PLAYER, true)
		set_collision_mask_value(ENEMY, true)


	elif self.is_in_group("drops") :

		# Drops found on:
		set_collision_layer_value(DROPS, true)
		# Drops scan for.
		set_collision_mask_value(PLAYER,true)

	elif self.is_in_group("player_projectile") :
		# Play_projectile found on:
		set_collision_layer_value(PLAYER_PROJECTILE, true)
		# Play_projectile scans for:
		set_collision_mask_value(ENEMY,true)

	elif self.is_in_group("player_weapon"):
		# Player_weapon found on:
		set_collision_layer_value(PLAYER_WEAPON, true)
		# Player_weapon scans for:
		set_collision_mask_value(ENEMY,true)
	elif self.is_in_group("enemy_projectile"):
		# Enemy projectile found on:
		set_collision_layer_value(ENEMY_PROJECTILE, true)
		# Enemy projectile scans for:
		set_collision_mask_value(PLAYER, true)

	else :
		push_warning("Caution : You've attach hurtbox to something that it doesn't
		have collision values defined for.", self.get_parent().get_parent())
		print(self.get_parent().get_groups())
		print(self.get_groups())



## Custom code that gets called when a valid Box-type enters our collision-area.
## We receive the colliding Box object, which means we can do getParent(hitbox)
##	allowing us to have easy access to the entire entity of which the 
##	colliding Box-type was attached to. 
## You may notice that the Generic type Box contains 
func _on_area_entered(hitbox: Box ) -> void:
	## If we somehow have a null Box, do nothing.
	if hitbox == null:
		push_warning("HIGH PRIORITY WARNING: Hit_Hurt_Box:_on_area_entered:
			hitbox == null. This should NOT be possible.")
		return

	# If my owner has a method called collision, call it. Otherwise don't as
	#	it'll brick the game.
	if owner.has_method("collision") :
		owner.collision(hitbox)
