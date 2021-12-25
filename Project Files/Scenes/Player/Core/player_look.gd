extends Node3D

var player

var mouse_move : Vector2 = Vector2.ZERO
var mouse_rotation_x : float = 0.0
var mouse_rotation_y : float = 0.0
var mouse_sensitivity : float = 0.003

var forward
var left

func _ready():
	player = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		# Vertical mouse look, clamped to -90..90 degrees
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sensitivity, deg2rad(-90), deg2rad(90))
		
func _physics_process(delta):
	forward = basis * Vector3.FORWARD
	left = basis * Vector3.LEFT
