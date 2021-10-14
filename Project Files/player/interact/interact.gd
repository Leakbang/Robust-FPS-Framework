extends RayCast

var Target = null

var can_use = true

var text_visible = false

func _ready():
	$InteractText.modulate = Color(0.81, 0.5, 0.09, 0)

func _physics_process(delta):
	if get_collider() and $InteractTimer.is_stopped():
		prompt()
	else:
		unprompt()
	
	if Input.is_key_pressed(KEY_E) or Input.is_joy_button_pressed(0, JOY_XBOX_Y):
		if can_use:
			if get_collider() and $InteractTimer.is_stopped():
				Target = get_collider()
				Target._Interact()
				$InteractTimer.start()
		
func prompt():
	if not text_visible:
		text_visible = true
		var animation_speed = 0.25
		$InteractTween.interpolate_property($InteractText, "margin_top", 90, 80, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.interpolate_property($InteractText, "modulate", Color(0.81, 0.5, 0.09, 0), Color(0.81, 0.5, 0.09, 1), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.start()

func unprompt():
	if text_visible:
		text_visible = false
		var animation_speed = 0.25
		$InteractTween.interpolate_property($InteractText, "margin_top", 80, 90, animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.interpolate_property($InteractText, "modulate", Color(0.81, 0.5, 0.09, 1), Color(0.81, 0.5, 0.09, 0), animation_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$InteractTween.start()
		$InteractTimer.start()
