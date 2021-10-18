extends Area

const Drag = 3
const Density = 5


var Vmass = []
var objects = []

func _process(delta):
	if objects:
		for i in range(0, objects.size()):
#			objects[i].add_central_force(Vector3(0, Vmass[i], 0))
			
			var bounding_box: AABB = objects[i].get_child(0).get_transformed_aabb()
			var bounding_box_size: Vector3 = bounding_box.size
			var area = (bounding_box_size.x + bounding_box_size.y + bounding_box_size.z) /10
			
			var velocity = objects[i].linear_velocity
			var drag_force = 0.5 * Drag * area * Density * -velocity.normalized() * velocity.length_squared()
			objects[i].add_central_force(drag_force)
			
			

func _on_Area_body_entered(body):
	objects.append(body)
	Vmass.append(body.weight)
	var bounding_box: AABB = body.get_child(0).get_transformed_aabb()
	var bounding_box_size: Vector3 = bounding_box.size
	var floaty = (bounding_box_size.x + bounding_box_size.y + bounding_box_size.z) /10
	print (body.name, floaty)


func _on_Area_body_exited(body):
	objects.erase(body)
	Vmass.erase(body.weight)
