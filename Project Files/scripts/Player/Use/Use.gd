extends RayCast

onready var tween = $tween
onready var UI = $"crosshair"
onready var use_icon = $"hand_icon"
onready var physics_joint = $use_pos/Joint

var mass_limit = 50
var throw_force = 20

var can_use = true

var object_grabbed = null
var Target = null
var last_used_item = null

onready var ogpos = $use_pos/StaticBody.translation

var use_pos


"""

Replace prompt function with animations

"""

func _ready():
	use_icon.set("visible", false)
	UI.set("visible", false)

func _physics_process(_delta):
	Target = get_collider()
	use_pos = get_collision_point()
	if get_collider() and $use_timer.is_stopped() and Target.is_in_group("Useable"):
		prompt()
		UI.set("visible", false)
	elif get_collider() and Target.owner.is_in_group("Terminal"):
		UI.set("visible", false)
		Target.owner.is_mouse_inside = true
		last_used_item = Target.owner
		var v_c = get_collision_point ()
		Target.owner.virutal_cursor = v_c
	elif not object_grabbed and $use_timer.is_stopped() and get_collider() is RigidBody and get_collider().mass <= mass_limit:
		prompt()
		UI.set("visible", false)
	else:
		if last_used_item:
			last_used_item.is_mouse_inside = false
		UI.set("visible", true)
		unprompt()
#		if object_grabbed:
#			DrawDebug.draw_line_3d(object_grabbed.global_transform.origin, $use_pos/StaticBody.global_transform.origin, Color(0,0,1))
		if get_collider():
			$use_pos/StaticBody.global_transform.origin = use_pos
		else:
			$use_pos/StaticBody.translation = ogpos
		
#Decrease mouse sensivity based on the weight of object

	# On key press
	if Input.is_action_pressed("use"):
		if get_collider() and Target is RigidBody:
			object_grabbed = Target
			object_grabbed.set_collision_layer_bit(0, false)
			object_grabbed.set_collision_mask_bit(0, false)
			var pth = object_grabbed.get_path()
			physics_joint.set_node_b(pth)
#		if can_use:
#			can_use = false
		if get_collider() and $use_timer.is_stopped() and Target.is_in_group("Useable"):
			Target._Interact()
			$use_timer.start()
			
		
	if Input.is_action_pressed("use_alt"):
		# alternative use
		release()
		
func release():
	object_grabbed = null
	physics_joint.set_node_b("")

"""
Replace prompt function with animations
"""


func prompt():
	pass

func unprompt():
	pass
