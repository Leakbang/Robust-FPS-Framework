extends Spatial

var going_up = true
var moving = false

onready var body = $Elevator

func activate():
	if going_up:
		moving = true

func _process(delta):
	if moving:
		if body.get_global_transform().origin.y > 20:
			going_up = false
		if going_up:
			body.add_central_force(Vector3(0, 300, 0))
		else:
			body.add_central_force(Vector3(0, 5, 0))
