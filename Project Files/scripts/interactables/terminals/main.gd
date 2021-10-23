extends Spatial
class_name Terminal

export (NodePath) var cursor_sprite

var quad_mesh_size
var is_mouse_inside = false
var is_mouse_held = false
var last_mouse_pos3D = null
var last_mouse_pos2D = null
var virutal_cursor = null

onready var node_viewport = $Viewport
onready var node_quad = $Quad
onready var node_area = $Quad/Area

func _ready():
	pass


func _process(_delta):
	pass


func _input(event):
	var is_mouse_event = false
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if event is mouse_event:
			is_mouse_event = true
			break
			
	if is_mouse_event and is_mouse_inside:
		handle_mouse(event)
	elif not is_mouse_event:
		node_viewport.input(event)


func handle_mouse(event):
	quad_mesh_size = node_quad.mesh.size

	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed
	var mouse_pos3D = find_mouse()

	if is_mouse_inside:
		mouse_pos3D = node_area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO


	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	
	
	mouse_pos2D.x += quad_mesh_size.x / 2
	mouse_pos2D.y += quad_mesh_size.y / 2

	mouse_pos2D.x = mouse_pos2D.x / quad_mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / quad_mesh_size.y


	mouse_pos2D.x = mouse_pos2D.x * node_viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * node_viewport.size.y

	event.position = mouse_pos2D
	event.global_position = mouse_pos2D

	last_mouse_pos2D = mouse_pos2D
	get_node(cursor_sprite).rect_position = last_mouse_pos2D 
	
	node_viewport.input(event)


func find_mouse():
	var result = virutal_cursor
	if result:
		return result
	else:
		return null
