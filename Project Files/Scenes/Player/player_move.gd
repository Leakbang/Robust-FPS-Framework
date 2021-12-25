extends RigidDynamicBody3D

var forwards_movement : float = 0.0
var sideways_movement : float = 0.0

var wishdir : Vector3

func _input(event):
	forwards_movement = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	sideways_movement = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")

# Stuttery Movement

func _integrate_forces(state):
	wishdir = Vector3(sideways_movement, 0, forwards_movement).normalized()
	#state.add_constant_central_force(wishdir * 2)
	# Movement friction (Also check if on the ground)
	var drag_force = 1.0 * -linear_velocity.normalized() * linear_velocity.length_squared()
	var d_force = Vector3(drag_force.x, 0, drag_force.z)
	
	#state.add_constant_central_force(wishdir * 5 + d_force)
	state.apply_central_force(wishdir * 250 + d_force)
