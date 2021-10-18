extends Area

const Drag = 3
const Density = 5

onready var water_level = $Surface.get_global_transform().origin.y

var object_mass = []
var objects = []

func _process(delta):
	if objects:
		for i in range(0, objects.size()):
			var bounding_box: AABB = objects[i].get_child(0).get_transformed_aabb()
			var bounding_box_size: Vector3 = bounding_box.size
			var area = bounding_box_size.x /5
			var top = bounding_box.position.y + bounding_box_size.y / 2.0
			var bottom = bounding_box.position.y - bounding_box_size.y / 2.0
			
			DrawDebug.draw_box(bounding_box.position, Vector3(bounding_box_size.x, bounding_box_size.y, bounding_box_size.z), Color(0, 1, 0))
			
			var velocity = objects[i].linear_velocity
			var drag_force = 0.5 * Drag * area * Density * -velocity.normalized() * velocity.length_squared()
			
			var buoyant_force: Vector3
			
			if top < water_level:
				buoyant_force.y = object_mass[i] + 10
			else:
				var immersion = (water_level - bottom) / bounding_box_size.y
				buoyant_force.y = object_mass[i] * immersion
			
			objects[i].add_central_force(drag_force + buoyant_force)

func _on_Area_body_entered(body):
	if body is RigidBody:
		objects.append(body)
		object_mass.append(body.weight)
		print(water_level)


func _on_Area_body_exited(body):
	if body is RigidBody:
		objects.erase(body)
		object_mass.erase(body.weight)
