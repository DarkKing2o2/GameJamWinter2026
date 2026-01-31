###################################### INFO ###################################
## Abstract class that other sub-types inherit from; doing it this way to 
##	abstract away the problem of 'what TYPE of object hit me?'- you got 
##	hit by a Box, that's it that's all, now fuck off.
##
## All Box collisions are handled by GoDot's internal Area collision detection,
##	we're simply leaching off of that signal to trigger our custom code.
##
## A common misconception is that this is a Notification-like system. Not in the 
##	slightest.
## Boxes are INCAPABLE of TELLING/NOTIFYING or DETECTING/KNOWING.
## Here's what happens:
## Godots internal collision system does the Notifications. 
## Boxes simply sit around like Jabba the Hutt waiting around for Godot to generate
##	a area_entered(area: Area2D) signal, which the Jabba the Hutt as conveniently
##	tapped into. 
## When Godot's collision system detects that a collision occurred, it creates a signal
##	event, adds the Area2D object which defined itself as something that can be 
##	collided with (Layer), and slaps that signal on the ass as it makes that noise
##	horse people make when they slap their horse on the ass to send it running. 
##	This signal gets sent to the object which defined that it would like to know when
##	something collides with it.
##	So what we get is the following animation:
##					<*Godot*: is anyone about to run into someone else...>
##	<I wanna know when I run into something>					<I'm something that can be ran into.>


##					<*Godot*: Looking looking, searching searching...>
##		<I wanna know when I run into something>		<I'm something that can be ran into.>


##					<*Godot*: is anyone about to run into someone else...>
##		<I wanna know when I run into something>*BONK*<I'm something that can be ran into.>

##					<*Godot*: Ah HA! Better let him know...>
##		<I wanna know when I run into something>	<I'm something that can be ran into.>

##					<*Godot*: *Tinker Craft Craft*>
##		<I wanna know when I run into something>		<I'm something that can be ran into.>

##					<*Godot*: Done!> <SIGNAL=THE OBJECT YOU RAN INTO>
##		<I wanna know when I run into something>			<I'm something that can be ran into.>

##					<*Godot*: HEY YOU, this is for you...> 
##		<I wanna know when I run into something <SIGNAL=THE OBJECT YOU RAN INTO>>	<I'm something that can be ran into.>

##					<*Godot*: Back to scanning...> 
##		<Oh shit I hit "THE OBJECT YOU RAN INTO">							<I'm something that can be ran into.>

## This is both the default Godot functionality and exactly what happens with Boxes. Boxes are objects after all.
## Boxes can be both things at once: something that wants to know when it ran into something and something that can be ran into.
## Godot unwittingly ends up passing around Boxes via signals. 
## Boxes are simply objects that define what they want/are at compile time (ie hard-coded).
## Boxes happen to be, by design, castable to a Generic (Box) allowing them to be man-handled at runtime
##	without causing type-casting errors.
## Boxes that want to be notified about collisions happen to be able to, by design, call their owner's functions
##	so long as the owner has implemented them.
## Boxes also happen to be heavily under-utilized which is the reason you kept thinking:
##	"Ok, I understand that but still, why did you make them?",
## 	as you read this explanation. 
## Boxes are over-built. But the Limbo AI library has their own version of boxes in it's demos directory 
##	that are simpler and do a bit more, which make them a good example of what Boxes COULD be, and more.
##
## 	<I wanna know when I run into something>	<*Godot*: >
@abstract
class_name Box extends Area2D

## Frankly, a poor choice. Pretty much I tied in damage into the box itself.
##	It SHOULD have been part of the stats and the box could have just 
##	passed along that or the owner of the box could have a method
##	that returns the owners stats.
## Anyway, just holds the damage that this box will deal when it collides with another
##	object, SHOULD that object utilize it. ie Boxes don't deal damage, they are
##	at MOST a carrier pigeon network for passing along NOTIFICATIONS of collisions.
##	
var damage := 0

@onready var child_collision_mask = $CollisionShape2D

## Enums that are used by the other scripts.
enum {
	PLAYER = 2,
	PLAYER_PROJECTILE = 3,
	ENEMY = 4,
	ENEMY_PROJECTILE = 5,
	DROPS = 6,
	PLAYER_WEAPON = 7,
}

## Godot's version of defining set & get for a variable as part
##	of the variable definition.
## Function() for 'blipping' debugging info about this box into the console.
## Automatically 'resets' itself allowing you to spam 'blips'.
## Note, been a while since this has been updated, some values might not return 
##	anything of value. But it shouldn't crash.
@export var blip_verbose_info: bool = false:
	set(new_value) :
		blip_verbose_info = false
		print("################# Hit_Hurt_Box ################")
		print ("My parent is: ", get_parent())
		print ("My top level value is: ", self.top_level, " and my childs: ")
		if ( child_collision_mask == null):
			print("Whooops, path to child_collision_mask is NULL")
		else:
			print(child_collision_mask.get_path())
			print("child_collision_mask's owner is: ", child_collision_mask.get_owner() )
		print("")

		print ("My tree is: ") ; print(get_tree_string_pretty())
		print ("My groups are: ")
		for group in self.get_groups():
			print (group)
		print("I have ", get_child_count() , " children and they are: ")
		for child in self.get_children():
			print(child)

		var tempAdder : String = ""
		print("My collision values are : ")
		print("Layer")
		# Print first 4 values of layer
		for n in range(1 ,5 ):
			if get_collision_layer_value(n) == true:
				tempAdder = tempAdder + str(n)
			else:
				tempAdder = tempAdder + "_"
		print (tempAdder)
		tempAdder = ""
		print("")
		#print next 4
		for n in range(5 ,9):
			if get_collision_layer_value(n) == true:
				tempAdder = tempAdder + str(n)
			else:
				tempAdder = tempAdder + "_"
		print (tempAdder)
		tempAdder = ""
		print("")
		print("MASK")
		# Print first 4 values of Mask
		for n in range(1 ,5):
			if get_collision_mask_value(n) == true:
				tempAdder = tempAdder + str(n)
			else:
				tempAdder = tempAdder + "_"
		print (tempAdder)
		tempAdder = ""
		print("")
		for n in range(5 ,9):
			if get_collision_mask_value(n) == true:
				tempAdder = tempAdder + str(n)
			else:
				tempAdder = tempAdder + "_"
		print (tempAdder)
		tempAdder = ""
		print("")


# NOTE: Possible future change I'd like to make.
# Collision Layers
#| Layer | Contents           |
#| ----- | ------------------ |
#| 1	| Walls/Boundaries		|
#| 5	| XP Pickup				|

#| 9	| Player (Hitbox)		|
#| 10	| Player Projectiles	|
#| 11	| Player Weapon			|

#| 17	| Enemies (Hitbox)		|
#| 18	| Enemy Projectiles  	|
#| 19	| Enemy Detection Range	|
#| 20	| Enemy Attack Range	|

func _ready() -> void:
	## For debugging.
	#print(get_children())
	pass
