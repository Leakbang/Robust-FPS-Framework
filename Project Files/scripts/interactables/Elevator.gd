extends Spatial

var going_up = true
var moving = false

onready var body = $Elevator

func activate():
	if going_up:
		moving = true

func _process(delta):
	if moving:
		var bounding_box: AABB = $Elevator/Floor.get_transformed_aabb()
		var bounding_box_size: Vector3 = bounding_box.size
		
		var top = bounding_box.position.y + bounding_box_size.y / 2.0
		var bottom = bounding_box.position.y - bounding_box_size.y / 2.0
		
		DrawDebug.draw_box(bounding_box.position, Vector3(bounding_box_size.x, bounding_box_size.y, bounding_box_size.z), Color(0, 1, 0))
			
		
		if top > $Top.get_global_transform().origin.y:
			body.sleeping = true;
			going_up = false
		if going_up:
			body.add_central_force(Vector3(0, 300, 0))
