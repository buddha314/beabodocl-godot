extends Node3D

## Debug script to visualize collision shapes
## Attach to Main node to see collision shape orientations

var output_lines = []

func _ready():
	log_msg("\n=== COLLISION SHAPE DEBUG ===")
	var walls_parent = get_node("../Environment/HexagonalRoom")
	
	log_msg("Wall parent found: " + str(walls_parent != null))
	if walls_parent:
		log_msg("Children: " + str(walls_parent.get_child_count()))
	
	for i in range(1, 7):
		var wall_path = "../Environment/HexagonalRoom/Wall" + str(i)
		var wall = get_node_or_null(wall_path)
		
		if not wall:
			log_msg("\nWall%d: NOT FOUND at path %s" % [i, wall_path])
			continue
		
		log_msg("\nWall%d: Found" % i)
		var static_body = wall.get_node_or_null("StaticBody3D")
		
		if not static_body:
			log_msg("  No StaticBody3D found")
			continue
		
		var collision_shape = static_body.get_node_or_null("CollisionShape3D")
		
		if not collision_shape:
			log_msg("  No CollisionShape3D found")
			continue
		
		# Get transforms
		var wall_transform = wall.global_transform
		var collision_transform = collision_shape.global_transform
		
		# Get rotation in degrees
		var wall_rotation = wall_transform.basis.get_euler() * 180.0 / PI
		var collision_rotation = collision_transform.basis.get_euler() * 180.0 / PI
		
		log_msg("  Wall position: %s" % wall_transform.origin)
		log_msg("  Wall rotation Y: %.1f°" % wall_rotation.y)
		log_msg("  Collision position: %s" % collision_transform.origin)
		log_msg("  Collision rotation Y: %.1f°" % collision_rotation.y)
		log_msg("  Collision facing: %s" % (-collision_transform.basis.z))
		
		# Create visual debug mesh
		create_debug_box(collision_transform, i)
	
	# Write to file
	write_log_file()

func log_msg(message: String):
	"""Add message to output and print to console"""
	print(message)
	output_lines.append(message)

func write_log_file():
	"""Write debug output to file"""
	var file_path = "res://debug/collision_debug_output.log"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		for line in output_lines:
			file.store_line(line)
		file.close()
		
		# Get absolute path
		var absolute_path = ProjectSettings.globalize_path(file_path)
		log_msg("\n=== LOG FILE WRITTEN ===")
		log_msg("Absolute path: " + absolute_path)
	else:
		print("ERROR: Could not write log file")

func create_debug_box(transform: Transform3D, wall_num: int):
	"""Create a semi-transparent debug box to visualize collision shape"""
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(4.619, 4.0, 0.2)
	mesh_instance.mesh = box_mesh
	
	# Semi-transparent red material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.0, 0.0, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Show both sides
	mesh_instance.material_override = material
	
	# Apply transform
	mesh_instance.global_transform = transform
	
	add_child(mesh_instance)
	log_msg("  Created debug box for Wall%d" % wall_num)
