extends Spatial

var roundedval = 0

func _process(_delta):
	roundedval = round($Door.rotation_degrees.y)
	if roundedval == 0:
		pass
