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


var use_pos


"""

Replace prompt function with animations

"""

func _ready():
	use_icon.set("visible", false)
	UI.set("visible", false)

func _physics_process(delta):
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
		
#Decrease mouse sensivity based on the weight of object

	if object_grabbed:
		object_grabbed.add_central_force(Vector3(0, 100,0))

	# On key press
	if Input.is_action_pressed("use"):
		if get_collider() and Target is RigidBody:
			object_grabbed = Target
			var pth = object_grabbed.get_path()
			physics_joint.set_node_b(pth)
#			tween.interpolate_property(Target, "translation",Target.global_transform.origin, $use_pos.global_transform.origin, 0.1, 4, 2)
#			tween.start()
#			object_grabbed = Target
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
