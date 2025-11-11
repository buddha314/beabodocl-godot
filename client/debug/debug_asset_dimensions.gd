extends Node3D

# Debug script to measure actual asset dimensions
var log_messages = []

func _ready():
	log_msg("=== ASSET DIMENSIONS DEBUG ===")
	
	# Check wall dimensions
	var wall = get_node_or_null("/root/Main/Environment/HexagonalRoom/Wall2")
	if wall:
		measure_asset(wall, "Wall2")
	
	# Load and measure screen asset
	log_msg("\n" + "=".repeat(50))
	var screen_scene = load("res://models/screen.glb")
	if screen_scene:
		var screen_instance = screen_scene.instantiate()
		add_child(screen_instance)
		await get_tree().process_frame
		measure_asset(screen_instance, "Screen Asset")
		screen_instance.queue_free()
	
	log_msg("\n" + "=".repeat(50))
	write_log_file()

func measure_asset(node: Node3D, label: String):
	log_msg("\n--- " + label + " ---")
	log_msg("Global position: " + str(node.global_position))
	log_msg("Global rotation (deg): " + str(node.rotation_degrees))
	
	# Find MeshInstance3D to get actual mesh bounds
	var mesh_instance = find_mesh_instance(node)
	if mesh_instance:
		var aabb = mesh_instance.get_aabb()
		log_msg("Mesh AABB size: " + str(aabb.size))
		log_msg("Mesh AABB position: " + str(aabb.position))
		
		# Transform AABB to global space
		var global_aabb_size = aabb.size * node.scale
		log_msg("Global AABB size (with scale): " + str(global_aabb_size))
		
		# Get mesh transform
		var mesh_xform = mesh_instance.transform
		log_msg("Mesh local position: " + str(mesh_xform.origin))
		log_msg("Mesh local scale: " + str(mesh_instance.scale))
		
		# Calculate thickness (assuming Z is depth/thickness)
		log_msg("\nDimensions:")
		log_msg("  Width (X): " + str(aabb.size.x) + " m")
		log_msg("  Height (Y): " + str(aabb.size.y) + " m")
		log_msg("  Thickness (Z): " + str(aabb.size.z) + " m")
	else:
		log_msg("ERROR: Could not find MeshInstance3D")

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
	var file = FileAccess.open("res://debug/asset_dimensions.log", FileAccess.WRITE)
	if file:
		for msg in log_messages:
			file.store_line(msg)
		file.close()
		print("\n>>> Log written to: res://debug/asset_dimensions.log")
	else:
		print("ERROR: Could not write log file")
