extends Node3D

@onready var camera:Camera3D = $Marker3D/Camera3D
@onready var player:CharacterBody3D = $Player

func _physics_process(delta):
	var mouse_viewport:Vector2 = get_viewport().get_mouse_position()
	var mouse_3d:Vector3 = camera.project_ray_normal(mouse_viewport)
	player.look_target = mouse_3d
