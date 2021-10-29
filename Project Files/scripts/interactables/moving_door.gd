extends RigidBody

var move = false

func activate():
	move = true
	print ("true")

func _physics_process(delta):
	if move:
		add_central_force(Vector3(100, 0, 0))
#
#func _integrate_forces(state):
#	if move:
#		print ("moving")
#		add_central_force(Vector3(2100, 0, 0))
