extends Node3D

# Debug script that saves output to a file
var log_output: String = ""

func _ready():
	log("=== FLOOR GEOMETRY DEBUG ===")
	log("Floor position: " + str(global_position))
	log("Floor rotation (degrees): " + str(rotation_degrees))
	log("Floor scale: " + str(scale))
	
	var mesh_instance = find_mesh_instance(self)
	if mesh_instance and mesh_instance.mesh:
		var mesh = mesh_instance.mesh
		log("\nMesh found: " + str(mesh))
		log("Surface count: " + str(mesh.get_surface_count()))
		
		for i in range(mesh.get_surface_count()):
			var arrays = mesh.surface_get_arrays(i)
			if arrays.size() > 0:
				var vertices = arrays[Mesh.ARRAY_VERTEX]
				log("\nSurface " + str(i) + " vertices:")
				log("Vertex count: " + str(vertices.size()))
				
				for v_idx in range(min(10, vertices.size())):
					log("  V" + str(v_idx) + ": " + str(vertices[v_idx]))
				
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
					log("\nBounds:")
					log("  Min: " + str(min_pos))
					log("  Max: " + str(max_pos))
					log("  Size: " + str(max_pos - min_pos))
	
	log("=== END FLOOR DEBUG ===")
	
	await get_tree().process_frame
	debug_walls()
	save_log_to_file()

func debug_walls():
	log("\n=== WALL DEBUG ===")
	var walls_parent = get_parent().get_node_or_null("HexagonalRoom")
	if walls_parent:
		for child in walls_parent.get_children():
			log("\n" + child.name + ":")
			log("  Position: " + str(child.global_position))
			log("  Rotation (degrees): " + str(child.rotation_degrees))
			var forward = -child.global_transform.basis.z
			log("  Facing direction: " + str(forward))
			log("  Facing angle (degrees): " + str(rad_to_deg(atan2(forward.x, forward.z))))
	
	log("\n=== VERTEX MARKERS DEBUG ===")
	var vertices_parent = get_parent().get_node_or_null("DebugVertices")
	if vertices_parent:
		for child in vertices_parent.get_children():
			log(child.name + ": " + str(child.global_position))
	
	log("=== END DEBUG ===")

func log(message: String):
	print(message)
	log_output += message + "\n"

func save_log_to_file():
	var file = FileAccess.open("res://debug_geometry.log", FileAccess.WRITE)
	if file:
		file.store_string(log_output)
		file.close()
		print("\n>>> Debug log saved to: res://debug_geometry.log")
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
