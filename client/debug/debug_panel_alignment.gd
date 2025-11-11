extends Node3D

## Debug script to verify panel alignment with walls
## Attach to Main or CollisionDebug node

var output_lines = []

func _ready():
	log_msg("\n=== PANEL ALIGNMENT DEBUG ===")
	
	# Get the panels parent
	var panels_parent = get_node("../Environment/Panels")
	var walls_parent = get_node("../Environment/HexagonalRoom")
	
	log_msg("Panels parent found: " + str(panels_parent != null))
	log_msg("Walls parent found: " + str(walls_parent != null))
	
	# Panel to Wall mapping
	var panel_wall_map = {
		"ChatPanel": "Wall1",
		"DocumentPanel": "Wall3",
		"VizPanel": "Wall5"
	}
	
	for panel_name in panel_wall_map.keys():
		var wall_name = panel_wall_map[panel_name]
		
		var panel = get_node_or_null("../Environment/Panels/" + panel_name)
		var wall = get_node_or_null("../Environment/HexagonalRoom/" + wall_name)
		
		if not panel:
			log_msg("\n%s: NOT FOUND" % panel_name)
			continue
		
		if not wall:
			log_msg("\n%s: Wall %s NOT FOUND" % [panel_name, wall_name])
			continue
		
		log_msg("\n=== %s -> %s ===" % [panel_name, wall_name])
		
		# Get mesh dimensions
		var panel_mesh = find_mesh_instance(panel)
		var wall_mesh = find_mesh_instance(wall)
		
		if panel_mesh and panel_mesh.mesh:
			var panel_aabb = panel_mesh.mesh.get_aabb()
			log_msg("Panel AABB size: %s" % panel_aabb.size)
			log_msg("Panel depth (Z): %.3f m" % panel_aabb.size.z)
			log_msg("Panel local transform: %s" % panel_mesh.transform)
			log_msg("Panel local basis Z: %s" % panel_mesh.transform.basis.z)
		
		if wall_mesh and wall_mesh.mesh:
			var wall_aabb = wall_mesh.mesh.get_aabb()
			log_msg("Wall AABB size: %s" % wall_aabb.size)
			log_msg("Wall depth (Z): %.3f m" % wall_aabb.size.z)
		
		# Check if mesh has internal rotation
		if panel_mesh:
			log_msg("Panel mesh local rotation: %s" % (panel_mesh.transform.basis.get_euler() * 180.0 / PI))
		
		# Get transforms
		var panel_transform = panel.global_transform
		var wall_transform = wall.global_transform
		
		# Get rotations in degrees
		var panel_rotation = panel_transform.basis.get_euler() * 180.0 / PI
		var wall_rotation = wall_transform.basis.get_euler() * 180.0 / PI
		
		# Get positions
		var panel_pos = panel_transform.origin
		var wall_pos = wall_transform.origin
		
		# Get facing directions
		var panel_facing = -panel_transform.basis.z
		var wall_facing = -wall_transform.basis.z
		
		# Calculate distance from panel to wall
		var distance = panel_pos.distance_to(wall_pos)
		
		log_msg("Panel position: %s" % panel_pos)
		log_msg("Wall position: %s" % wall_pos)
		log_msg("Distance: %.3f m" % distance)
		log_msg("")
		log_msg("Panel rotation Y: %.1f°" % panel_rotation.y)
		log_msg("Wall rotation Y: %.1f°" % wall_rotation.y)
		log_msg("Rotation difference: %.1f°" % (panel_rotation.y - wall_rotation.y))
		log_msg("")
		log_msg("Panel facing: %s" % panel_facing)
		log_msg("Wall facing: %s" % wall_facing)
		
		# Check if panel is facing same direction as wall (should be)
		var facing_dot = panel_facing.dot(wall_facing)
		log_msg("Facing alignment (dot product): %.3f" % facing_dot)
		log_msg("  (1.0 = same direction, -1.0 = opposite, 0.0 = perpendicular)")
		
		# Calculate what direction panel SHOULD face (toward center)
		var center = Vector3(0, 1.6, 0)  # Center of room at eye level
		var to_center = (center - panel_pos).normalized()
		log_msg("")
		log_msg("Direction TO CENTER: %s" % to_center)
		log_msg("Current panel facing: %s" % panel_facing)
		var center_alignment = panel_facing.dot(to_center)
		log_msg("Alignment with center: %.3f (should be ~1.0)" % center_alignment)
		
		# Create visual markers
		create_debug_marker(panel_pos, Color.GREEN, panel_name)
		create_debug_marker(wall_pos, Color.BLUE, wall_name)
	
	# Write to file
	write_log_file()

func log_msg(message: String):
	"""Add message to output and print to console"""
	print(message)
	output_lines.append(message)

func write_log_file():
	"""Write debug output to file"""
	var file_path = "res://debug/panel_alignment_output.log"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		for line in output_lines:
			file.store_line(line)
		file.close()
		
		var absolute_path = ProjectSettings.globalize_path(file_path)
		log_msg("\n=== LOG FILE WRITTEN ===")
		log_msg("Absolute path: " + absolute_path)
	else:
		print("ERROR: Could not write log file")

func create_debug_marker(position: Vector3, color: Color, label: String):
	"""Create a small sphere marker at the given position"""
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.1
	sphere_mesh.height = 0.2
	mesh_instance.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 2.0
	mesh_instance.material_override = material
	
	mesh_instance.global_position = position
	add_child(mesh_instance)
	
	log_msg("  Created %s marker at %s" % [label, position])

func find_mesh_instance(node: Node) -> MeshInstance3D:
	"""Recursively find MeshInstance3D in node tree"""
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var result = find_mesh_instance(child)
		if result:
			return result
	
	return null
