extends Node3D

@onready var camera:Camera3D = $Marker3D/Camera3D
@onready var player:CharacterBody3D = $Player
@onready var ball := $Ball

func _process(delta):
	const MOUSE_3D_HEIGHT:float = 10
	var mouse_viewport:Vector2 = get_viewport().get_mouse_position()
	var mouse_3d := viewport_to_3d(mouse_viewport)
	
	mouse_3d[1] = MOUSE_3D_HEIGHT
	ball.global_position = mouse_3d
	player.look_target = mouse_3d

# Converts a 2D point on the viewport to a 3D point in space via raycast collision with a physics body
func viewport_to_3d(viewport_pos:Vector2) -> Vector3:
	const MASK:int = 0xFFFFFFFF
	const RAY_LEN_MARGIN:float = 0.2
	
#	var ray_len:float = camera.global_position.length() * (1 + RAY_LEN_MARGIN)
	var ray_len:float = 2000
	var space_state = get_world_3d().direct_space_state
	var ray_start:Vector3 = camera.project_ray_origin(viewport_pos)
	var ray_end:Vector3 = ray_start + camera.project_ray_normal(viewport_pos) * ray_len
	var raycast_query := PhysicsRayQueryParameters3D.create(ray_start, ray_end, MASK)
	var raycast_result:Dictionary = space_state.intersect_ray(raycast_query)
	
	if raycast_result.has("position"):
		return raycast_result["position"] 
	return Vector3.ZERO
