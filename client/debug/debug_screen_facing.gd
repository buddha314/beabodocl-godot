extends Node3D

# Debug script to visualize screen forward directions
# Creates cubes 0.5m in front of each screen to show where they face

var log_messages = []

func _ready():
	log_msg("=== SCREEN FACING DEBUG ===")
	log_msg("Creating debug cubes 0.5m from screen normals")
	
	var screens_node = get_node_or_null("/root/Main/Environment/Screens")
	if not screens_node:
		log_msg("ERROR: Could not find Screens node")
		write_log_file()
		return
	
	for screen in screens_node.get_children():
		debug_screen_forward(screen)
	
	write_log_file()

func debug_screen_forward(screen: Node3D):
	var screen_name = screen.name
	log_msg("\n--- " + screen_name + " ---")
	
	# Get screen's global transform
	var global_xform = screen.global_transform
	var position = global_xform.origin
	var forward = -global_xform.basis.z  # Godot uses -Z as forward
	
	log_msg("Screen position: " + str(position))
	log_msg("Screen rotation (deg): " + str(screen.rotation_degrees))
	log_msg("Forward direction (-Z): " + str(forward))
	
	# Find corresponding wall
	var wall_num = screen_name.replace("Screen", "Wall")
	var wall = get_node_or_null("/root/Main/Environment/HexagonalRoom/" + wall_num)
	if wall:
		log_msg("Wall position: " + str(wall.global_position))
		log_msg("Wall rotation (deg): " + str(wall.rotation_degrees))
		var wall_forward = -wall.global_transform.basis.z
		log_msg("Wall facing: " + str(wall_forward))
		var distance = position.distance_to(wall.global_position)
		log_msg("Distance screen<->wall: " + str(distance) + " m")
	
	# Calculate cube position 0.5m in front of screen
	var cube_pos = position + (forward * 0.5)
	log_msg("Debug cube position: " + str(cube_pos))
	
	# Create debug cube
	create_debug_cube(cube_pos, screen_name)
	
	# Calculate direction to center for reference
	var to_center = Vector3.ZERO - position
	to_center.y = 0  # Ignore height
	to_center = to_center.normalized()
	
	var forward_2d = Vector3(forward.x, 0, forward.z).normalized()
	var alignment = forward_2d.dot(to_center)
	
	log_msg("Direction to center: " + str(to_center))
	log_msg("Alignment with center: " + str(alignment) + " (should be ~1.0)")

func create_debug_cube(pos: Vector3, label: String):
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(0.3, 0.3, 0.3)  # 30cm cube for visibility
	mesh_instance.mesh = box_mesh
	
	# Create material with bright color
	var material = StandardMaterial3D.new()
	if label.contains("Screen2"):
		material.albedo_color = Color(1, 0, 0)  # Red
	elif label.contains("Screen4"):
		material.albedo_color = Color(0, 1, 0)  # Green
	else:
		material.albedo_color = Color(0, 0, 1)  # Blue
	
	mesh_instance.material_override = material
	mesh_instance.position = pos
	
	add_child(mesh_instance)
	log_msg("Created debug cube at: " + str(pos))

func log_msg(message: String):
	log_messages.append(message)
	print(message)

func write_log_file():
	var file = FileAccess.open("res://debug/screen_facing_output.log", FileAccess.WRITE)
	if file:
		for msg in log_messages:
			file.store_line(msg)
		file.close()
		print("\n>>> Log written to: res://debug/screen_facing_output.log")
	else:
		print("ERROR: Could not write log file")
