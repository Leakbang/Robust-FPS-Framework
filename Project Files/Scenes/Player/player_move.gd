extends RigidDynamicBody3D

var forwards_movement : float = 0.0
var sideways_movement : float = 0.0

var wishdir : Vector3

func _input(event):
	forwards_movement = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	sideways_movement = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")

# Stuttery Movement

func _integrate_forces(state):
	wishdir = Vector3(forwards_movement, 0, sideways_movement)
	state.add_constant_central_force(wishdir)
	
	# Movement friction (Also check if on the ground)
	var velocity = linear_velocity
	var drag_force = 1.0 * -velocity.normalized() * velocity.length_squared()
	
	state.add_constant_central_force(Vector3(drag_force.x, 0, drag_force.z))
