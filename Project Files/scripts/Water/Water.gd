extends Area

onready var water_level = $Surface.global_transform.origin.y

var objects = []

var debug_color = Color(0, 1, 0)

func _physics_process(_delta):
	if objects:
		for i in range(0, objects.size()):
			var bounding_box: AABB = objects[i].get_child(0).get_transformed_aabb()
			var bounding_box_size: Vector3 = bounding_box.size
			var top = bounding_box.position.y + bounding_box_size.y
			var bottom = bounding_box.position.y - bounding_box_size.y / 2
			
			var buoyant_force: Vector3
			var weight = objects[i].weight
			
			if top < water_level:
				buoyant_force.y = weight + (0.2 * weight)
				debug_color = Color(1, 0, 0)
			else:
				var immersion = abs(water_level - bottom) / bounding_box_size.y
				debug_color = Color(0, 0, 1)
				buoyant_force.y = weight * immersion
				
			DrawDebug.draw_box(bounding_box.position, Vector3(bounding_box_size.x, bounding_box_size.y, bounding_box_size.z), debug_color)
			objects[i].add_central_force(buoyant_force)

func _on_Area_body_entered(body):
	if body is RigidBody:
		
		var groups = body.get_groups()
		if groups.has("Metal"):
			body.gravity_scale = 2
		if groups.has("Wood"):
			body.gravity_scale = 1

		objects.push_front(body)


func _on_Area_body_exited(body):
	if objects.has(body):
		objects.erase(body)
