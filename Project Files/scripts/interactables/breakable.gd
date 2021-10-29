extends RigidBody

var threshold = 20.0

func _integrate_forces(state):
	var total_force = Vector3.ZERO
	for i in range (0, state.get_contact_count()):
		var object = state.get_contact_collider_object(i)
		if object is RigidBody:
			var normal = state.get_contact_local_normal(i)
			var f_weight_normal = normal * normal.dot(Vector3(0, object.weight,0))
			f_weight_normal = f_weight_normal.round()
			#print(f_weight_normal)
			# Force = mass * acceleration
			var impulse = state.get_contact_impulse(i) * state.get_contact_local_normal(i)
			total_force += impulse
			
			$Label.text = String(total_force)
			
			if total_force.x > threshold or total_force.y > threshold or total_force.z > threshold:
				print("Broken")
