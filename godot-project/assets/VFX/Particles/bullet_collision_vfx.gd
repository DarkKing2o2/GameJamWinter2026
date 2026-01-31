extends GPUParticles2D


## Method() for setting the particles' emission direction based the given a
##	normilized vector. Only sets direction of particle spawn not the velocity.
func direction_of_impact(direction : Vector2) -> void:
	#Vector3direction [default: Vector3(1, 0, 0)]
	#Unit vector specifying the particles' emission direction.
	self.process_material.set_direction(Vector3(direction.x,direction.y,0))
	
	# Start emitting particles
	self.set_emitting(true)
	
## Method() for listening to the one_shot timer and upon signal, deleting the
##	instance of self.
func _on_finished() -> void:
	self.queue_free()
