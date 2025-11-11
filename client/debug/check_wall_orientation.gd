extends Node3D

# Script to verify wall.glb orientation follows Z-Forward standard
# According to BLENDER_ASSET_PIPELINE.md:
# - Front face should point toward -Z in Godot
# - Width along X-axis
# - Height along Y-axis

var log_messages = []

func _ready():
	log_msg("=== WALL ORIENTATION CHECK ===")
	log_msg("Checking wall.glb against Z-Forward standard")
	log_msg("")
	
	# Load the wall asset directly
	var wall_scene = load("res://models/wall.glb")
	if not wall_scene:
		log_msg("ERROR: Could not load wall.glb")
		write_log_file()
		return
	
	# Instantiate at origin with no rotation
	var wall = wall_scene.instantiate()
	add_child(wall)
	wall.global_position = Vector3.ZERO
	wall.global_rotation = Vector3.ZERO
	
	await get_tree().process_frame
	
	# Find the mesh
	var mesh_instance = find_mesh_instance(wall)
	if not mesh_instance:
		log_msg("ERROR: No MeshInstance3D found in wall.glb")
		wall.queue_free()
		write_log_file()
		return
	
	var aabb = mesh_instance.get_aabb()
	log_msg("--- MESH BOUNDING BOX ---")
	log_msg("AABB Position: " + str(aabb.position))
	log_msg("AABB Size: " + str(aabb.size))
	log_msg("")
	
	# According to Z-Forward standard:
	# - Width (X): The horizontal span
	# - Height (Y): The vertical span
	# - Depth/Thickness (Z): Should be minimal (thin wall)
	log_msg("--- DIMENSION ANALYSIS ---")
	log_msg("X (Width):     %.3f m" % aabb.size.x)
	log_msg("Y (Height):    %.3f m" % aabb.size.y)
	log_msg("Z (Thickness): %.3f m" % aabb.size.z)
	log_msg("")
	
	# Expected: Wall should be wider than it is thick
	var is_correct_x = aabb.size.x > aabb.size.z
	var is_correct_y = aabb.size.y > aabb.size.z
	
	log_msg("--- ORIENTATION CHECKS ---")
	log_msg("Width (X) > Thickness (Z): " + ("✓ PASS" if is_correct_x else "✗ FAIL"))
	log_msg("Height (Y) > Thickness (Z): " + ("✓ PASS" if is_correct_y else "✗ FAIL"))
	log_msg("")
	
	# Check mesh vertices to see which way the face normal points
	var mesh = mesh_instance.mesh
	if mesh and mesh.get_surface_count() > 0:
		var arrays = mesh.surface_get_arrays(0)
		if arrays.size() > Mesh.ARRAY_NORMAL:
			var vertices = arrays[Mesh.ARRAY_VERTEX]
			var normals = arrays[Mesh.ARRAY_NORMAL]
			
			if vertices and normals and vertices.size() > 0:
				# Calculate average normal direction
				var avg_normal = Vector3.ZERO
				for normal in normals:
					avg_normal += normal
				avg_normal = avg_normal / normals.size()
				avg_normal = avg_normal.normalized()
				
				log_msg("--- NORMAL DIRECTION ---")
				log_msg("Average Normal: " + str(avg_normal))
				log_msg("")
				
				# For Z-Forward: Front face should point toward -Z
				# So the normal should have a significant negative Z component
				var points_negative_z = avg_normal.z < -0.5
				log_msg("Normal points toward -Z: " + ("✓ PASS" if points_negative_z else "✗ FAIL"))
				log_msg("  (Expected: Normal.z < -0.5, Got: %.3f)" % avg_normal.z)
				log_msg("")
	
	# Check the transform basis
	log_msg("--- TRANSFORM BASIS ---")
	var basis = mesh_instance.global_transform.basis
	log_msg("Forward (-Z): " + str(-basis.z))
	log_msg("Right (X):    " + str(basis.x))
	log_msg("Up (Y):       " + str(basis.y))
	log_msg("")
	
	# Final verdict
	log_msg("--- VERDICT ---")
	if is_correct_x and is_correct_y:
		log_msg("✓ Wall dimensions appear CORRECT for Z-Forward standard")
		log_msg("  Wall is wider (X) and taller (Y) than it is thick (Z)")
	else:
		log_msg("✗ Wall dimensions appear INCORRECT")
		log_msg("  Check Blender export settings:")
		log_msg("  - Forward should be -Z Forward")
		log_msg("  - Up should be +Y Up")
		log_msg("  - Apply All Transforms (Ctrl+A) before export")
	
	wall.queue_free()
	write_log_file()

func find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_mesh_instance(child)
		if result:
			return result
	return null

func log_msg(message: String):
	log_messages.append(message)
	print(message)

func write_log_file():
	var file = FileAccess.open("res://debug/wall_orientation_check.log", FileAccess.WRITE)
	if file:
		for msg in log_messages:
			file.store_line(msg)
		file.close()
		print("\n>>> Log written to: res://debug/wall_orientation_check.log")
	else:
		print("ERROR: Could not write log file")
