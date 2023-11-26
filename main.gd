extends Node3D

@onready var camera:Camera3D = $Marker3D/Camera3D
@onready var player:CharacterBody3D = $Player
@onready var ball := $Ball

func _process(delta):
	var mouse_viewport:Vector2 = get_viewport().get_mouse_position()
	var mouse_3d := viewport_to_3d(mouse_viewport)
	
	ball.global_position = mouse_3d
	player.look_target = mouse_3d


# Converts a 2D point on the viewport to a 3D point in space. Casts a ray from the camera origin 
# and through the mouse position on the viewport till it collides with a PhysicsBody3D object
func viewport_to_3d(viewport_pos:Vector2) -> Vector3:
	const MASK:int = 0x00000001 # Collide with only the floor

	var ray_len:float = 2000
	var space_state = get_world_3d().direct_space_state
	var ray_start:Vector3 = camera.project_ray_origin(viewport_pos)
	var ray_end:Vector3 = ray_start + camera.project_ray_normal(viewport_pos) * ray_len
	var raycast_query := PhysicsRayQueryParameters3D.create(ray_start, ray_end, MASK)
	var raycast_result:Dictionary = space_state.intersect_ray(raycast_query)
	
	if raycast_result.has("position"):
		return raycast_result["position"] 
	return Vector3.ZERO
