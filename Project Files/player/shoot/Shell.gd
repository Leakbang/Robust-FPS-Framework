extends RigidBody

func _ready():
	$ShellImpactSound.pitch_scale = rand_range(0.95, 1.05)

func _on_LifetimeTimer_timeout():
	self.set_sleeping(true)
	print("now sleeping")

#func _on_AudioTimer_timeout():
#	$ShellImpactSound.play()


func _on_Shell_body_shape_entered(body_id, body, body_shape, local_shape):
	$ShellImpactSound.play()
