class_name VisionMaster extends Node3D

## Abstracts the details of character vision. A coarse test (area intersection) is used before a 
## fine test (ray intersections forming a cone) is performed.

## As per the Godot documentation, physics collisions are updated all at once, not immediately after 
## moving objects.  Check vision_area.collision_mask if an object is not being detected. 
## Note that rays originate from the center of the character rather than the edge of its mesh.
## TODO: use signals instead for area intersection testing if vision is laggy for fast-moving objects

const MIN_RAYS:int = 2

@export var debug_mode:bool = false
@export var cone_angle:float = 30 # Vision angle [deg]
@export var cone_length:float = 15 # Vision range [m]
@export var ray_density:float = 0.3 # Number of rays per degree

@onready var vision_area := $Area3D # For coarse testing
@onready var debug_cone := $DebugCone

var vision_cone:Array: # The cone itself
	get: 
		if vision_cone == null:
			vision_cone = generate_vision_cone()
		return vision_cone

# ----------------------------------------------------------- BUILT-IN METHODS


func _ready():
	var cone_mesh:CylinderMesh
	if debug_mode:
		debug_setup()
	
	
func _physics_process(delta):
	(vision_area.get_child(0).shape).radius = cone_length
#	vision_area.global_position = global_position


# ----------------------------------------------------------- PUBLIC METHODS
 

# Determines if the provided physics body is within our cone of vision.
func object_visible(phys_object:PhysicsBody3D) -> bool:
	var space_state := get_world_3d().direct_space_state
	var phys_query:PhysicsRayQueryParameters3D
	var ray_collider

	# Fine test - check for raycast collisions in a cone:
	if  vision_area.overlaps_body(phys_object): 
		for ray in vision_cone:
			phys_query = PhysicsRayQueryParameters3D.create \
					(Vector3.ZERO, ray, vision_area.collision_mask, [get_parent()])
			ray_collider = (space_state.intersect_ray(phys_query))["collider"]

			if ray_collider == phys_object:
				return true
	return false


# ----------------------------------------------------------- PRIVATE METHODS

func debug_setup() -> void:
	var cone_mesh:CylinderMesh = debug_cone.mesh as CylinderMesh
	
	debug_cone.show()
	
	cone_mesh.height = cone_length
	cone_mesh.bottom_radius = tan(deg_to_rad(cone_angle)/2) * cone_length
	debug_cone.position.z -= cone_length/2


# Creates an array of rays representing the vision cone
func generate_vision_cone() -> Array:
	var result:Array
	var num_rays := int(max(MIN_RAYS, cone_angle * ray_density))
	var ray_angle_delta:float = cone_angle/(num_rays - 1)

	for ray_index in num_rays: # 0...n-1
		result.append(cone_length * Vector2.UP.rotated(ray_index * ray_angle_delta))

	return result
