extends RayCast

onready var physics_joint = $"6DOF_joint"

var mass_limit = 50
var throw_force = 20

var can_use = true

var object_grabbed = null
var Target = null
var last_used_item = null

var distance = null

var use_pos

# UI
var using = false
var played = false
var looking = false
var should_prompt = false
"""

Replace prompt function with animations

"""

func _physics_process(_delta):
	Target = get_collider()
	use_pos = get_collision_point()
	if can_use:
		if get_collider():
			if $use_timer.is_stopped():
				if Target.is_in_group("Useable"):
					looking = true
				if Target.is_in_group("Pickup"):
					looking = true
				else: 
					looking = false
			# Terminal
			if Target.owner.is_in_group("Terminal"):
				Target.owner.is_mouse_inside = true
				last_used_item = Target.owner
				var v_c = get_collision_point ()
				Target.owner.virutal_cursor = v_c
			
		else:
			looking = false
			if last_used_item:
				last_used_item.is_mouse_inside = false
	if object_grabbed:
		distance = $hand.global_transform.origin.distance_to(object_grabbed.global_transform.origin)
		if distance > 5.0:
			print("Drop it")
			release()
			
	update_hud()
		#DrawDebug.draw_line_3d($hand.global_transform.origin, object_grabbed.global_transform.origin, Color(0, 1, 0))
		#DrawDebug.draw_line_3d($"6DOF_joint".global_transform.origin , object_grabbed.global_transform.origin, Color(0, 1, 0))
#Decrease mouse sensivity based on the weight of object

	# On key press
	if Input.is_action_pressed("use"):
		# use
		if can_use:
			if get_collider():
				if $use_timer.is_stopped():
					if Target.is_in_group("Useable"):
						Target._Interact()
						$use_timer.start()
				if Target.is_in_group("Pickup"):
					object_grabbed = Target
					object_grabbed.set_collision_layer_bit(0, false)
					object_grabbed.set_collision_mask_bit(0, false)
					physics_joint.set_node_b(object_grabbed.get_path())
				# Set can use to false
			
		
	if Input.is_action_pressed("use_alt"):
		# secondary use
		if object_grabbed:
			release()
		
func release():
	if object_grabbed:
		object_grabbed.set_collision_layer_bit(0, true)
		object_grabbed.set_collision_mask_bit(0, true)
		physics_joint.set_node_b("")
		object_grabbed = null

"""
Replace prompt function with animations
"""

func update_hud():
	if should_prompt:
		if looking:
			$AnimationPlayer.play("Use")
			should_prompt = false
	if not should_prompt:
		if not looking:
			$AnimationPlayer.play_backwards("Use")
			should_prompt = true
