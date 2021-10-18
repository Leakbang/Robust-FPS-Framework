extends Area

const Drag = 3
const Density = 5


var Vmass = []
var objects = []

func _process(delta):
	if objects:
		for i in range(0, objects.size()):
#			objects[i].add_central_force(Vector3(0, Vmass[i], 0))
#			AABB(objects[i].translation, objects[i].get_scale())
			var AreaSize = objects[i].get_scale()
			var velocity = objects[i].linear_velocity
			var dragforce = 0.5 * Drag * Density * AreaSize * velocity * velocity
			objects[i].add_central_force(Vector3(0, dragforce.y, 0))

func _on_Area_body_entered(body):
	objects.append(body)
	Vmass.append(body.weight)


func _on_Area_body_exited(body):
	objects.erase(body)
	Vmass.erase(body.weight)
