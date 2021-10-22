extends Spatial


export (Material) var on_material
export (Material) var off_material

export (bool) var is_on

func _ready():
	if is_on:
		$OmniLight.light_energy = 1
		$Bulb.mesh.surface_set_material(0, on_material)
	else:
		$OmniLight.light_energy = 0
		$Bulb.mesh.surface_set_material(0, off_material)

func activate(value):
	$OmniLight.light_energy = value
#		$Bulb.mesh.surface_set_material(0, off_material)
	

