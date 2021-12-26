extends Terminal

export (NodePath) var Target

func _on_Up_pressed():
	var node = get_node(Target)
	node.activate()
