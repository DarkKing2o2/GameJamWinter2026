extends CPUParticles2D

## Method() for setting the particles emmission direction given a normilized
##	vector.
func spawn_blood(impact_vector : Vector2) -> void:
	# Set spawn direction
	self.set_direction(impact_vector)
	await(0.1)
	print_debug("impact_vector: " , impact_vector)
	print_debug("Blood Dir: " , self.direction)
	# Set emitting to true
	self.set_emitting(true)



func _on_self_deletion_timer_timeout() -> void:
	# Delete ourselfs
	self.queue_free()
