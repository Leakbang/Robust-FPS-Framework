extends Spatial

# The size of the quad mesh itself.
var quad_mesh_size
# Used for checking if the mouse is inside the Area
var is_mouse_inside = false
# Used for checking if the mouse was pressed inside the Area
var is_mouse_held = false
# The last non-empty mouse position. Used when dragging outside of the box.
var last_mouse_pos3D = null
# The last processed input touch/mouse event. To calculate relative movement.
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
	# Check if the event is a non-mouse/non-touch event
	var is_mouse_event = false
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if event is mouse_event:
			is_mouse_event = true
			break

	# If the event is a mouse/touch event and/or the mouse is either held or inside the area, then
	# we need to do some additional processing in the handle_mouse function before passing the event to the viewport.
	# If the event is not a mouse/touch event, then we can just pass the event directly to the viewport.
	if is_mouse_event and (is_mouse_inside or is_mouse_held):
		handle_mouse(event)
	elif not is_mouse_event:
		node_viewport.input(event)


# Handle mouse events inside Area. (Area.input_event had many issues with dragging)
func handle_mouse(event):
	# Get mesh size to detect edges and make conversions. This code only support PlaneMesh and QuadMesh.
	quad_mesh_size = node_quad.mesh.size

	# Detect mouse being held to mantain event while outside of bounds. Avoid orphan clicks
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed

	# Find mouse position in Area
	var mouse_pos3D = find_mouse()

	# Check if the mouse is outside of bounds, use last position to avoid errors
	# NOTE: mouse_exited signal was unrealiable in this situation
	if is_mouse_inside:
		# Convert click_pos from world coordinate space to a coordinate space relative to the Area node.
		# NOTE: affine_inverse accounts for the Area node's scale, rotation, and translation in the scene!
		mouse_pos3D = node_area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO


	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	
	

	# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
	# We need to convert it into the following range: 0 -> quad_size
	mouse_pos2D.x += quad_mesh_size.x / 2
	mouse_pos2D.y += quad_mesh_size.y / 2
	# Then we need to convert it into the following range: 0 -> 1
	mouse_pos2D.x = mouse_pos2D.x / quad_mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / quad_mesh_size.y

	# Finally, we convert the position to the following range: 0 -> viewport.size
	mouse_pos2D.x = mouse_pos2D.x * node_viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * node_viewport.size.y
	# We need to do these conversions so the event's position is in the viewport's coordinate system.

	# Set the event's position and global position.
	event.position = mouse_pos2D
	event.global_position = mouse_pos2D

	# If the event is a mouse motion event...
#	if event is InputEventMouseMotion:
#		# If there is not a stored previous position, then we'll assume there is no relative motion.
#		if last_mouse_pos2D == null:
#			event.relative = Vector2(0, 0)
#		# If there is a stored previous position, then we'll calculate the relative position by subtracting
#		# the previous position from the new position. This will give us the distance the event traveled from prev_pos
#		else:
#			event.relative = mouse_pos2D - last_mouse_pos2D
#	# Update last_mouse_pos2D with the position we just calculated.
	last_mouse_pos2D = mouse_pos2D
	$Viewport/GUI/Panel/TextureRect.rect_position = last_mouse_pos2D 
	
	node_viewport.input(event)


func find_mouse():

	var result = virutal_cursor

	#var result = get_world().direct_space_state.intersect_ray(from, to, [], node_area.collision_layer,false,true) #for 3.1 changes

	if result:
		return result
	else:
		return null
