extends StaticBody

var BoxCount: int = 0

func _ready():
	$TerminalInterface.visible = false

func _Interact():
	$TerminalInterface.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$TerminalInterface/ColorRect/Counter.text = String(BoxCount)

func _on_Quit_pressed():
	$TerminalInterface.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Area_body_entered(body):
	if body.is_in_group("Crate"):
		BoxCount += 1


func _on_Area_body_exited(body):
	if body.is_in_group("Crate"):
		BoxCount -= 1
