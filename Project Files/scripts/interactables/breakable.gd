extends RigidBody
class_name Breakable

export (float) var health = 100

export (float) var threshold = 30.0

func _integrate_forces(state):
	var total_force = Vector3.ZERO
	for i in range (0, state.get_contact_count()):
		var object = state.get_contact_collider_object(i)
		if object is RigidBody:
			var impulse = state.get_contact_impulse(i) * state.get_contact_local_normal(i)
			impulse = impulse * 5
			impulse = impulse.round()
			total_force += impulse
			
			$Label.text = String(total_force)
			
			if abs(total_force.x) > threshold:
				print(total_force)
				damage(abs(total_force.x)/2)
			if abs(total_force.y) > threshold:
				print(total_force)
				damage(abs(total_force.y)/2)
			if abs(total_force.z) > threshold:
				print(total_force)
				damage(abs(total_force.z)/2)
	
func damage(amount):
	health -= amount
	print("health:", health)
	if health <= 0:
		print("dead")
		self.queue_free()
