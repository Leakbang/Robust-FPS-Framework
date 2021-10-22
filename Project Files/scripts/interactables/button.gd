extends StaticBody

export (NodePath) var Target

func _Interact():
	var node = get_node(Target)
	node.activate()
