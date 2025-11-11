extends Node3D

# Script to verify and help fix wall orientations to face center of room
# Based on hexagonal room pattern from HEXAGON_WALL_PATTERN.md
# All walls should face inward toward the center (0, 0, 0)

var output_lines = []
var room_center = Vector3(0, 0, 0)  # Center of the hexagonal room
var debug_cubes = []  # Store references to created debug cubes

func _ready():
	log_msg("=== WALL FACING ORIENTATION DEBUG ===")
	log_msg("Purpose: Verify all walls face toward room center")
	log_msg("Creating debug cubes 0.2m from walls along their forward direction")
	log_msg("Room center: " + str(room_center))
	log_msg("")
	
	# Wait one frame for scene to fully load
	await get_tree().process_frame
	
	# Find the HexagonalRoom node
	var hex_room = get_node_or_null("/root/Main/Environment/HexagonalRoom")
	
	if not hex_room:
		log_msg("ERROR: Could not find HexagonalRoom node")
		log_msg("Expected path: /root/Main/Environment/HexagonalRoom")
		write_log_file()
		return
	
	log_msg("Found HexagonalRoom with " + str(hex_room.get_child_count()) + " children")
	log_msg("")
	
	var wall_count = 0
	var correct_count = 0
	var incorrect_walls = []
	
	# Analyze each wall
	for child in hex_room.get_children():
		if child.name.begins_with("Wall"):
			wall_count += 1
			var is_correct = analyze_wall(child, wall_count)
			if is_correct:
				correct_count += 1
			else:
				incorrect_walls.append(child.name)
	
	# Summary
	log_msg("")
	log_msg("=== SUMMARY ===")
	log_msg("Total walls analyzed: " + str(wall_count))
	log_msg("Correctly facing inward: " + str(correct_count))
	log_msg("Incorrectly oriented: " + str(wall_count - correct_count))
	
	if incorrect_walls.size() > 0:
		log_msg("")
		log_msg("⚠️ WALLS NEEDING CORRECTION:")
		for wall_name in incorrect_walls:
			log_msg("  - " + wall_name)
		log_msg("")
		log_msg("See detailed analysis above for each wall's recommended rotation")
		log_msg("")
		log_msg("DEBUG CUBES:")
		log_msg("  GREEN cubes = Wall facing CORRECT (toward center)")
		log_msg("  RED cubes = Wall facing INCORRECT (away from center)")
	else:
		log_msg("")
		log_msg("✓ ALL WALLS CORRECTLY ORIENTED")
		log_msg("All debug cubes should be GREEN")
	
	write_log_file()

func analyze_wall(wall: Node3D, wall_num: int) -> bool:
	"""Analyze a single wall's orientation and return true if facing inward"""
	log_msg("--- " + wall.name + " ---")
	
	var pos = wall.global_position
	var transform_basis = wall.global_transform.basis
	
	# Get the wall's forward direction (negative Z in Godot)
	# Only consider XZ plane for horizontal facing
	var wall_forward_3d = -transform_basis.z
	var wall_forward = Vector3(wall_forward_3d.x, 0, wall_forward_3d.z).normalized()
	
	# Calculate the direction from wall to center (only in XZ plane)
	var to_center_3d = room_center - pos
	var to_center = Vector3(to_center_3d.x, 0, to_center_3d.z).normalized()
	
	# Create debug cube 0.2m from wall along its forward direction
	var cube_distance = 0.2
	var cube_position = pos + (wall_forward_3d.normalized() * cube_distance)
	
	# Calculate the dot product to see if wall faces center
	# dot = 1: perfectly aligned toward center
	# dot = 0: perpendicular
	# dot = -1: facing away from center
	var alignment = wall_forward.dot(to_center)
	
	# Calculate the angle between forward direction and to_center
	var angle_to_center = rad_to_deg(acos(clamp(alignment, -1.0, 1.0)))
	
	log_msg("Position: " + str(pos))
	log_msg("Current rotation (degrees): " + str(wall.rotation_degrees))
	log_msg("")
	log_msg("Wall forward direction: " + str(wall_forward))
	log_msg("Direction to center: " + str(to_center))
	log_msg("Alignment (dot product): %.3f" % alignment)
	log_msg("Angle from center: %.1f°" % angle_to_center)
	
	# Check if wall is facing inward (within 30 degrees of center)
	var is_facing_inward = alignment > 0.866  # cos(30°) ≈ 0.866
	
	# Create debug cube
	var cube_color = Color.GREEN if is_facing_inward else Color.RED
	create_debug_cube(cube_position, cube_color, wall.name)
	log_msg("Debug cube at: " + str(cube_position) + " (" + ("GREEN" if is_facing_inward else "RED") + ")")
	
	if is_facing_inward:
		log_msg("✓ STATUS: CORRECT - Wall faces inward")
	else:
		log_msg("✗ STATUS: INCORRECT - Wall needs adjustment")
		
		# Calculate recommended rotation
		var current_y_rot = wall.rotation.y
		
		# Calculate the angle we need to rotate toward center
		# atan2 gives us the angle in the XZ plane
		var desired_angle = atan2(to_center.x, to_center.z)
		var correction_needed = rad_to_deg(desired_angle - current_y_rot)
		
		# Normalize to -180 to 180 range
		while correction_needed > 180:
			correction_needed -= 360
		while correction_needed < -180:
			correction_needed += 360
		
		log_msg("")
		log_msg("RECOMMENDED FIX:")
		log_msg("  Current Y rotation: %.1f°" % rad_to_deg(current_y_rot))
		log_msg("  Rotate by: %.1f°" % correction_needed)
		log_msg("  Target Y rotation: %.1f°" % rad_to_deg(desired_angle))
		log_msg("")
		log_msg("In Godot scene editor:")
		log_msg("  Select: Environment/HexagonalRoom/" + wall.name)
		log_msg("  Set rotation Y to: %.3f radians (%.1f°)" % [desired_angle, rad_to_deg(desired_angle)])
		
		# Show the corrected transform matrix
		var corrected_transform = Transform3D()
		corrected_transform = corrected_transform.rotated(Vector3.UP, desired_angle)
		corrected_transform.origin = pos
		log_msg("")
		log_msg("Or copy this transform line into main.tscn:")
		log_msg('transform = Transform3D(%.6f, 0, %.6f, 0, 1, 0, %.6f, 0, %.6f, %.3f, %.3f, %.3f)' % [
			corrected_transform.basis.x.x, corrected_transform.basis.x.z,
			corrected_transform.basis.z.x, corrected_transform.basis.z.z,
			pos.x, pos.y, pos.z
		])
	
	log_msg("")
	return is_facing_inward

func create_debug_cube(position: Vector3, color: Color, label: String):
	"""Create a small debug cube at the specified position with the given color"""
	# Create mesh instance
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = "DebugCube_" + label
	
	# Create a small box mesh (0.2m cube)
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(0.2, 0.2, 0.2)
	mesh_instance.mesh = box_mesh
	
	# Create material with the specified color
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = 1.0  # Increased brightness
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED  # Always visible
	mesh_instance.material_override = material
	
	# Set position
	mesh_instance.global_position = position
	
	# Add to Environment node so cubes are visible in the scene
	var env_node = get_node_or_null("/root/Main/Environment")
	if env_node:
		env_node.add_child(mesh_instance)
		debug_cubes.append(mesh_instance)
		log_msg("Created debug cube at: " + str(position) + " for " + label)
	else:
		# Fallback to adding as child of this script
		add_child(mesh_instance)
		debug_cubes.append(mesh_instance)
		log_msg("Created debug cube (fallback) at: " + str(position) + " for " + label)

func log_msg(message: String):
	"""Add message to output buffer and print to console"""
	print(message)
	output_lines.append(message)

func write_log_file():
	"""Write debug output to file - REQUIRED for AI collaboration"""
	var file_path = "res://debug/wall_facing_debug.log"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		for line in output_lines:
			file.store_line(line)
		file.close()
		
		# Print absolute path so AI knows where to read
		var absolute_path = ProjectSettings.globalize_path(file_path)
		print("\n=== LOG FILE WRITTEN ===")
		print("Absolute path: " + absolute_path)
		print("You can read this file to see all wall orientation details")
	else:
		print("ERROR: Could not write log file")
