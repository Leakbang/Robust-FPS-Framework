extends RigidDynamicBody3D

var f_move : float = 0.0
var s_move : float = 0.0

var wishdir : Vector3

var forward : Vector3
var left : Vector3

func _input(event):
	f_move = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	s_move = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")


func _integrate_forces(state):
	
	forward = $Head.forward
	left = $Head.left
	
	wishdir = (s_move * left) + (f_move * forward)
	var move_dir = Vector3(wishdir.x, 0, wishdir.z).normalized()

	var drag_force = 1.0 * -linear_velocity.normalized() * linear_velocity.length_squared()
	var d_force = Vector3(drag_force.x, 0, drag_force.z)

	state.apply_central_force(move_dir * 900 + d_force)
 
