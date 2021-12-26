extends Control


func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass


func _on_Play_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene("res://Scenes/Levels/obstacle_course.tscn")


func _on_EXIT_pressed():
	get_tree().quit()
