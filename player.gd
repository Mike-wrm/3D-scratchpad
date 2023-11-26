extends CharacterBody3D

@export var speed:float = 20

const GRAVITY:float = 20

var look_target:Vector3

func _process(delta):
	look_at(look_target, Vector3.UP)
	rotation.x = 0 # Constant look height
	
func _physics_process(delta):
	var move_vector := Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		move_vector.z -= 1
	if Input.is_action_pressed("move_down"):
		move_vector.z += 1
	if Input.is_action_pressed("move_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vector.x += 1
	
	if move_vector.length() > 1:
		move_vector.normalized()
	move_vector *= speed
		
	if not is_on_floor():
		move_vector.y -= GRAVITY
		
	velocity = move_vector 
	move_and_slide()
