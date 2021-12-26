extends Camera

onready var player = get_parent()

var mouse_move : Vector2 = Vector2.ZERO
var mouse_rotation_x : float = 0.0
var mouse_rotation_y : float = 0.0
var mouse_sensitivity : float = 0.1

var forward : Vector3
var left : Vector3

var y_offset : float = 1.25   

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = event.relative * 0.1
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -90, 90)
		mouse_rotation_y -= event.relative.x * mouse_sensitivity

func _physics_process(delta):
	
	var forward_vec = Vector3.RIGHT
	var left_vec = Vector3.BACK
	var basis = get_transform().basis
	forward = basis.xform(forward_vec)
	left = basis.xform(left_vec)
	
	rotation_degrees = Vector3(mouse_rotation_x, mouse_rotation_y, 0)

