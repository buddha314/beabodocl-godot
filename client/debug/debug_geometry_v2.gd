extends Node3D

# Debug script to log geometry and transforms to a file
# Outputs to res://debug_geometry.log which can be read by tools

var log_output: String = ""

func _ready():
	log_msg("=== FLOOR GEOMETRY DEBUG ===")
	log_msg("Floor position: " + str(global_position))
	log_msg("Floor rotation (degrees): " + str(rotation_degrees))
	log_msg("Floor rotation (radians): " + str(rotation))
	log_msg("Floor scale: " + str(scale))
	log_msg("Floor transform:\n" + str(global_transform))
	
	var mesh_instance = find_mesh_instance(self)
	if mesh_instance and mesh_instance.mesh:
		var mesh = mesh_instance.mesh
		log_msg("\nMesh found: " + str(mesh))
		log_msg("Surface count: " + str(mesh.get_surface_count()))
		
		for i in range(mesh.get_surface_count()):
			var arrays = mesh.surface_get_arrays(i)
			if arrays.size() > 0:
				var vertices = arrays[Mesh.ARRAY_VERTEX]
				log_msg("\nSurface " + str(i) + " vertices:")
				log_msg("Vertex count: " + str(vertices.size()))
				
				for v_idx in range(min(10, vertices.size())):
					log_msg("  V" + str(v_idx) + ": " + str(vertices[v_idx]))
				
				if vertices.size() > 0:
					var min_pos = vertices[0]
					var max_pos = vertices[0]
					for v in vertices:
						min_pos.x = min(min_pos.x, v.x)
						min_pos.y = min(min_pos.y, v.y)
						min_pos.z = min(min_pos.z, v.z)
						max_pos.x = max(max_pos.x, v.x)
						max_pos.y = max(max_pos.y, v.y)
						max_pos.z = max(max_pos.z, v.z)
					log_msg("\nBounds:")
					log_msg("  Min: " + str(min_pos))
					log_msg("  Max: " + str(max_pos))
					log_msg("  Size: " + str(max_pos - min_pos))
	
	log_msg("=== END FLOOR DEBUG ===")
	
	await get_tree().process_frame
	debug_walls()
	save_log_to_file()

func debug_walls():
	log_msg("\n=== WALL DEBUG ===")
	var walls_parent = get_parent().get_node_or_null("HexagonalRoom")
	if walls_parent:
		for child in walls_parent.get_children():
			log_msg("\n" + child.name + ":")
			log_msg("  Position: " + str(child.global_position))
			log_msg("  Rotation (degrees): " + str(child.rotation_degrees))
			log_msg("  Rotation (radians): " + str(child.rotation))
			log_msg("  Scale: " + str(child.scale))
			log_msg("  Transform matrix:\n    " + str(child.global_transform).replace("\n", "\n    "))
			
			# Get the forward direction (which way the wall is facing)
			var forward = -child.global_transform.basis.z
			var right = child.global_transform.basis.x
			var up = child.global_transform.basis.y
			log_msg("  Facing direction (forward -Z): " + str(forward))
			log_msg("  Right direction (+X): " + str(right))
			log_msg("  Up direction (+Y): " + str(up))
			log_msg("  Facing angle (degrees): " + str(rad_to_deg(atan2(forward.x, forward.z))))
	
	log_msg("\n=== VERTEX MARKERS DEBUG ===")
	var vertices_parent = get_parent().get_node_or_null("DebugVertices")
	if vertices_parent:
		for child in vertices_parent.get_children():
			log_msg(child.name + ": " + str(child.global_position))
	
	log_msg("=== END DEBUG ===")

func log_msg(message: String):
	print(message)
	log_output += message + "\n"

func save_log_to_file():
	var log_path = "res://debug_geometry.log"
	var file = FileAccess.open(log_path, FileAccess.WRITE)
	if file:
		file.store_string(log_output)
		file.close()
		var abs_path = ProjectSettings.globalize_path(log_path)
		print("\n>>> Debug log saved to: " + abs_path)
		log_output = ""  # Clear for next run
	else:
		print("\n>>> ERROR: Could not write debug log file")

func find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_mesh_instance(child)
		if result:
			return result
	return null
