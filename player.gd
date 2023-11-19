extends CharacterBody3D

var look_target:Vector3

func _physics_process(delta):
	self.look_at(look_target, Vector3.UP)
	pass
	
