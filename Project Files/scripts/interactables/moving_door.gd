extends RigidBody

var move = false

func activate():
	move = true
	print ("true")

func _integrate_forces(state):
	if move:
		#TODO: Set the object to not sleeping
		add_central_force(Vector3(200, 0, 0))
		
		for i in range (0, state.get_contact_count()):
			var object = state.get_contact_collider_object(i)
			if object is RigidBody or object == null:
				pass
			else:
				move = false
