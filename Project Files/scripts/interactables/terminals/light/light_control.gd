extends Terminal

export (NodePath) var Target

func _on_HSlider_value_changed(value):
	var node = get_node(Target)
	node.activate(value)
