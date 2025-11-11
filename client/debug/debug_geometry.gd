extends Node3D

# Debug script to print actual floor hexagon geometry and wall rotations
# Attach this to the floor node temporarily to inspect vertices

func _ready():
	print("=== FLOOR GEOMETRY DEBUG ===")
	
	# Print floor transform
	print("Floor position: ", global_position)
	print("Floor rotation (degrees): ", rotation_degrees)
	print("Floor rotation (radians): ", rotation)
	print("Floor scale: ", scale)
	
	# Try to find the mesh in the imported scene
	var mesh_instance = find_mesh_instance(self)
	
	if mesh_instance:
		var mesh = mesh_instance.mesh
		if mesh:
			print("\nMesh found: ", mesh)
			print("Surface count: ", mesh.get_surface_count())
			
			for i in range(mesh.get_surface_count()):
				var arrays = mesh.surface_get_arrays(i)
				if arrays.size() > 0:
					var vertices = arrays[Mesh.ARRAY_VERTEX]
					print("\nSurface ", i, " vertices:")
					print("Vertex count: ", vertices.size())
					
					# Print first 10 vertices to see the pattern
					for v_idx in range(min(10, vertices.size())):
						print("  V", v_idx, ": ", vertices[v_idx])
					
					# Find min/max bounds
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
						print("\nBounds:")
						print("  Min: ", min_pos)
						print("  Max: ", max_pos)
						print("  Size: ", max_pos - min_pos)
	else:
		print("No MeshInstance3D found in floor node")
	
	print("=== END FLOOR DEBUG ===")
	
	# Now debug the walls
	await get_tree().process_frame
	debug_walls()

func debug_walls():
	print("\n=== WALL DEBUG ===")
	var walls_parent = get_parent().get_node_or_null("HexagonalRoom")
	if walls_parent:
		for child in walls_parent.get_children():
			print("\n", child.name, ":")
			print("  Position: ", child.global_position)
			print("  Rotation (degrees): ", child.rotation_degrees)
			print("  Rotation (radians): ", child.rotation)
			
			# Get the forward direction (which way the wall is facing)
			var forward = -child.global_transform.basis.z
			print("  Facing direction: ", forward)
			print("  Facing angle (degrees): ", rad_to_deg(atan2(forward.x, forward.z)))
	else:
		print("HexagonalRoom node not found")
	
	# Debug vertices
	print("\n=== VERTEX MARKERS DEBUG ===")
	var vertices_parent = get_parent().get_node_or_null("DebugVertices")
	if vertices_parent:
		for child in vertices_parent.get_children():
			print(child.name, ": ", child.global_position)
	else:
		print("DebugVertices node not found")
	
	print("=== END DEBUG ===")

func find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var result = find_mesh_instance(child)
		if result:
			return result
	
	return null
