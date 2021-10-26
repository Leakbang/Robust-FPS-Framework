extends RayCast

onready var UI = $"crosshair"
onready var use_icon = $"hand_icon"

var mass_limit = 50
var throw_force = 20

var last_used_item

var object_grabbed = null
var Target = null
var can_use = true
var text_visible = false

func _ready():
	use_icon.set("visible", false)
	UI.set("visible", false)

func _physics_process(delta):
	Target = get_collider();
	if get_collider() and $UseTimer.is_stopped() and Target.is_in_group("Useable"):
		prompt()
		UI.set("visible", false)
	elif get_collider() and Target.owner.is_in_group("Terminal"):
		UI.set("visible", false)
		Target.owner.is_mouse_inside = true
		last_used_item = Target.owner
		var v_c = get_collision_point ()
		Target.owner.virutal_cursor = v_c
	elif not object_grabbed and $UseTimer.is_stopped() and get_collider() is RigidBody and get_collider().mass <= mass_limit:
		prompt()
		UI.set("visible", false)
	else:
		if last_used_item:
			last_used_item.is_mouse_inside = false
		UI.set("visible", true)
		unprompt()
		
	# Drop object if it goes too far
	if object_grabbed:
		var vector = $UseRange.global_transform.origin - object_grabbed.global_transform.origin
		object_grabbed.linear_velocity = vector * 10
		object_grabbed.axis_lock_angular_x = true
		object_grabbed.axis_lock_angular_y = true
		object_grabbed.axis_lock_angular_z = true

		if vector.length() >= 5:
			object_grabbed.set_mode(0)
			release()

	# On key press
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if can_use:
			can_use = false
			if get_collider() and $UseTimer.is_stopped() and Target.is_in_group("Useable"):
				Target._Interact()
				$UseTimer.start()
			elif not object_grabbed:
					if get_collider() is RigidBody and $UseTimer.is_stopped() and Target.mass <= mass_limit:
						object_grabbed = Target
						object_grabbed.rotation_degrees.x = 0
						object_grabbed.rotation_degrees.z = 0
			else:
				release()
	else:
		can_use = true

		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			if object_grabbed:
				object_grabbed.linear_velocity = global_transform.basis.z * -throw_force
				release()
		
func release():
	object_grabbed.axis_lock_angular_x = false
	object_grabbed.axis_lock_angular_y = false
	object_grabbed.axis_lock_angular_z = false
	object_grabbed = null
	$UseTimer.start()
		
func prompt():
	if not text_visible:
		text_visible = true
		var animation_speed = 0.25
		use_icon.set("visible", true)
		$UseTween.start()

func unprompt():
	if text_visible:
		text_visible = false
		var animation_speed = 0.25
		use_icon.set("visible", false)
		$UseTimer.start()
