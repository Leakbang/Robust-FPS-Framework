extends RigidBody

func _ready():
	$ShellImpactSound.pitch_scale = rand_range(0.95, 1.05)

func _on_LifetimeTimer_timeout():
	set_sleeping(true)

func _on_Shell_body_shape_entered(body_id, body, body_shape, local_shape):
	$ShellImpactSound.play()
