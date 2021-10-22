extends RayCast

var mass_limit = 50
var throw_force = 20

var object_grabbed = null

var Target = null

var can_use = true

var text_visible = false

func _ready():
	$UseText.modulate = Color(0.98, 0.71, 0.08, 0)

func _physics_process(delta):
	Target = get_collider();
	if get_collider() and $UseTimer.is_stopped() and Target.is_in_group("Useable"):
		prompt("Use")
	elif get_collider() and $UseTimer.is_stopped() and Target.owner.is_in_group("Terminal"):
		prompt("Terminal")
		Target.owner.is_mouse_inside = true
		var v_c = get_collision_point ( )
		Target.owner.virutal_cursor = v_c
	elif not object_grabbed and $UseTimer.is_stopped() and get_collider() is RigidBody and get_collider().mass <= mass_limit:
		prompt("Pickup")
	else:
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
	if Input.is_key_pressed(KEY_E) or Input.is_joy_button_pressed(0, JOY_XBOX_Y):
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

		if Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.get_joy_axis(0, 7) >= 0.6:
			if object_grabbed:
				object_grabbed.linear_velocity = global_transform.basis.z * -throw_force
				release()
		
func release():
	object_grabbed.axis_lock_angular_x = false
	object_grabbed.axis_lock_angular_y = false
	object_grabbed.axis_lock_angular_z = false
	object_grabbed = null
	$UseTimer.start()
		
func prompt(text):
	if not text_visible:
		$UseText.text = text
		text_visible = true
		var animation_speed = 0.25
		$UseTween.interpolate_property($UseText, "margin_top", 90, 80, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$UseTween.interpolate_property($UseText, "modulate", Color(0.98, 0.71, 0.08, 0), Color(0.98, 0.71, 0.08, 1), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$UseTween.start()

func unprompt():
	if text_visible:
		text_visible = false
		var animation_speed = 0.25
		$UseTween.interpolate_property($UseText, "margin_top", 80, 90, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$UseTween.interpolate_property($UseText, "modulate", Color(0.98, 0.71, 0.08, 1), Color(0.98, 0.71, 0.08, 0), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$UseTween.start()
		$UseTimer.start()
