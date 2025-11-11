extends Node3D

# Debug script to visualize panel forward directions
# Creates small cubes 0.1m in front of each panel to show where they face

var log_messages = []

func _ready():
	log_msg("=== Panel Forward Direction Debug ===")
	log_msg("Creating debug cubes 0.1m from panel normals")
	
	var panels_node = get_node("/root/Main/Environment/Panels")
	if not panels_node:
		log_msg("ERROR: Could not find Panels node")
		write_log_file()
		return
	
	var panels = [
		panels_node.get_node("ChatPanel"),
		panels_node.get_node("DocumentPanel"),
		panels_node.get_node("VizPanel")
	]
	
	for panel in panels:
		if panel:
			debug_panel_forward(panel)
		else:
			log_msg("ERROR: Panel node not found")
	
	write_log_file()

func debug_panel_forward(panel: Node3D):
	var panel_name = panel.name
	log_msg("\n--- " + panel_name + " ---")
	
	# Get panel's global transform
	var global_xform = panel.global_transform
	var position = global_xform.origin
	var forward = -global_xform.basis.z  # Godot uses -Z as forward
	
	log_msg("Position: " + str(position))
	log_msg("Forward direction: " + str(forward))
	
	# Calculate cube position 0.1m in front of panel
	var cube_pos = position + (forward * 0.1)
	log_msg("Cube position: " + str(cube_pos))
	
	# Create debug cube
	create_debug_cube(cube_pos, panel_name)
	
	# Also calculate direction to center for reference
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
	box_mesh.size = Vector3(0.2, 0.2, 0.2)  # 20cm cube for visibility
	mesh_instance.mesh = box_mesh
	
	# Create material with bright color
	var material = StandardMaterial3D.new()
	if label.contains("Chat"):
		material.albedo_color = Color(1, 0, 0)  # Red
	elif label.contains("Document"):
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
	var file = FileAccess.open("res://debug/panel_forward_output.log", FileAccess.WRITE)
	if file:
		for msg in log_messages:
			file.store_line(msg)
		file.close()
		log_msg("Log written to: res://debug/panel_forward_output.log")
	else:
		print("ERROR: Could not write log file")
