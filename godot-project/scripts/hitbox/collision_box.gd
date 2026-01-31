####################################### INFO ####################################
## A script thats part of the Box family.
## Collision_box sets hard-coded values indicating the X layer it's on.
## Collision_box can be thought of as a HitBox; an object that defines that 
##	fellow Boxes can collide with it. It, however, doesn't have the capacity
##	to know that it was hit: it doesn't need to.
##	Great for static objects, walls, trees, programmers, etc.
## To use any Box sub-type: add to scene tree, set the group as needed, and add
##	a collision shape as a child. 
## At run time the Box-type gets the group its part of (the one you set), and uses
##	that to set it's Layer and Mask properties as hard-coded.
class_name CollisionBox extends Box

func _init() -> void:
	pass


func _ready() -> void:
	call_deferred("set_collision")


## Function for determining the type of collisions to set based on what group
## Box has been set to in the editor group panel.
##	CAUTION: NEVER use collision_layer & collision_mask. Doing so will fail to
##		set desired collisions.
##		Only use the setter methods().
func set_collision() -> void:
	collision_layer = 0
	collision_mask = 0
	damage = 10
# Godots Layer		 1   2   3   4   5   6   7   8
# Binary value 	    001 002 004 008 016 032 064 128
#| 1      \| Walls/Boundaries   |
#| 2     | Player             | = 2
#| 3     | Player Projectiles | = 4
#| 4     | Enemies            | = 8
#| 5     | Enemy Projectiles  |	= 16
#|-6-----| "drops" -----------| = 32
#|-7-----| "weapon"-----------| = 64
	if self.get_parent().is_in_group("player") :
		# Player found on:
		set_collision_layer_value(PLAYER, true)

	elif self.get_parent().is_in_group("enemy") :
		# Enemy found on:
		set_collision_layer_value(ENEMY, true)


	elif self.get_parent().is_in_group("drops") :
		# Drops found on:
		set_collision_layer_value(DROPS, true)

	elif self.get_parent().is_in_group("player_projectile") :
		# Play_projectile found on:
		set_collision_layer_value(PLAYER_PROJECTILE, true)

	elif self.get_parent().is_in_group("player_weapon"):
		# Player_weapon found on:
		set_collision_layer_value(PLAYER_WEAPON, true)

	else :
		push_warning("Caution : You've attach hurtbox to something that it doesn't
		have collision values defined for.", self.get_parent().get_parent())
