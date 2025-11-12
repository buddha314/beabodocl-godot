extends Label3D

# Visual debug HUD for VR

var left_controller: XRController3D
var right_controller: XRController3D
var log_file: FileAccess
var frame_count = 0

func _ready():
	# Position in front of camera
	await get_tree().process_frame
	
	# Open log file
	log_file = FileAccess.open("user://vr_debug.log", FileAccess.WRITE)
	if log_file:
		log_file.store_line("=== VR Debug Log Started ===")
		log_file.store_line("Time: " + Time.get_datetime_string_from_system())
		log_file.flush()
	
	# Find controllers
	left_controller = get_node_or_null("/root/Main/XROrigin3D/LeftHand")
	right_controller = get_node_or_null("/root/Main/XROrigin3D/RightHand")
	
	text = "Debug HUD Ready\n"
	if left_controller:
		text += "Left Controller: OK\n"
		if log_file:
			log_file.store_line("Left Controller found")
	else:
		text += "Left Controller: MISSING\n"
		if log_file:
			log_file.store_line("ERROR: Left Controller NOT found")
		
	if right_controller:
		text += "Right Controller: OK\n"
		if log_file:
			log_file.store_line("Right Controller found")
	else:
		text += "Right Controller: MISSING\n"
		if log_file:
			log_file.store_line("ERROR: Right Controller NOT found")
	
	if log_file:
		log_file.flush()

func _process(_delta):
	frame_count += 1
	
	var debug_text = "=== VR DEBUG ===\n\n"
	
	# XR Server info
	var world_scale = XRServer.world_scale
	
	debug_text += "World Scale: %.2f\n\n" % world_scale
	
	# Log every 60 frames (once per second at 60fps)
	if log_file and frame_count % 60 == 0:
		log_file.store_line("\n--- Frame %d ---" % frame_count)
		log_file.store_line("World scale: %.2f" % world_scale)
	
	# Left controller info
	if left_controller:
		var active = left_controller.get_is_active()
		var has_tracking = left_controller.get_tracker_hand() != XRPositionalTracker.TRACKER_HAND_UNKNOWN
		
		# Read action values directly - try multiple ways
		var grip = left_controller.get_float("grip")
		var trigger = left_controller.get_float("trigger")
		
		# Try Vector2 action
		var primary_vec = left_controller.get_vector2("primary")
		if primary_vec == null:
			primary_vec = Vector2.ZERO
		var thumbstick_vec = left_controller.get_vector2("thumbstick")
		if thumbstick_vec == null:
			thumbstick_vec = Vector2.ZERO
		
		# WORKAROUND: Try reading thumbstick as separate Float actions
		var thumb_x = left_controller.get_float("thumbstick_x")
		var thumb_y = left_controller.get_float("thumbstick_y")
		var thumb_float_vec = Vector2(thumb_x, thumb_y)
		
		# Also try reading the input directly from tracker
		var tracker = XRServer.get_tracker("left_hand")
		var tracker_primary = Vector2.ZERO
		if tracker:
			var raw_input = tracker.get_input("primary") if tracker.has_method("get_input") else null
			if raw_input != null and raw_input is Vector2:
				tracker_primary = raw_input
		
		debug_text += "LEFT (tracker='%s', pose='%s')\n" % [left_controller.tracker, left_controller.pose]
		debug_text += "  Active: %s | Tracking: %s\n" % [str(active), str(has_tracking)]
		debug_text += "  Grip: %.2f | Trigger: %.2f\n" % [grip, trigger]
		debug_text += "  primary: (%.2f, %.2f)\n" % [primary_vec.x, primary_vec.y]
		debug_text += "  thumbstick: (%.2f, %.2f)\n" % [thumbstick_vec.x, thumbstick_vec.y]
		debug_text += "  thumb_x/y: (%.2f, %.2f)\n" % [thumb_float_vec.x, thumb_float_vec.y]
		if tracker:
			debug_text += "  tracker.primary: (%.2f, %.2f)\n" % [tracker_primary.x, tracker_primary.y]
		
		# Try to get pose directly
		var tracker_obj = XRServer.get_tracker("/user/hand/left")
		if tracker_obj:
			debug_text += "  Tracker Found: YES\n"
			debug_text += "  Tracker Type: %s\n" % str(tracker_obj.type)
		else:
			debug_text += "  Tracker Found: NO\n"
		debug_text += "\n"
		
		if log_file and frame_count % 60 == 0:
			log_file.store_line("LEFT Controller:")
			log_file.store_line("  Tracker: %s" % left_controller.tracker)
			log_file.store_line("  Pose: %s" % left_controller.pose)
			log_file.store_line("  Active: %s" % str(active))
			log_file.store_line("  Has Tracking: %s" % str(has_tracking))
			log_file.store_line("  Grip: %.2f" % grip)
			log_file.store_line("  Trigger: %.2f" % trigger)
			log_file.store_line("  Primary Vec2: (%.2f, %.2f)" % [primary_vec.x, primary_vec.y])
	else:
		debug_text += "LEFT: NO CONTROLLER\n\n"
	
	# Right controller info
	if right_controller:
		var active = right_controller.get_is_active()
		var has_tracking = right_controller.get_tracker_hand() != XRPositionalTracker.TRACKER_HAND_UNKNOWN
		
		# Read action values directly
		var grip = right_controller.get_float("grip")
		var trigger = right_controller.get_float("trigger")
		var primary_vec = right_controller.get_vector2("primary")
		var thumbstick_vec = right_controller.get_vector2("thumbstick")
		
		debug_text += "\nRIGHT (tracker='%s', pose='%s')\n" % [right_controller.tracker, right_controller.pose]
		debug_text += "  Active: %s | Tracking: %s\n" % [str(active), str(has_tracking)]
		debug_text += "  Grip: %.2f | Trigger: %.2f\n" % [grip, trigger]
		debug_text += "  primary: (%.2f, %.2f)\n" % [primary_vec.x, primary_vec.y]
		debug_text += "  thumbstick: (%.2f, %.2f)\n" % [thumbstick_vec.x, thumbstick_vec.y]
		
		# Try to get pose directly
		var tracker_obj = XRServer.get_tracker("/user/hand/right")
		if tracker_obj:
			debug_text += "  Tracker Found: YES\n"
			debug_text += "  Tracker Type: %s\n" % str(tracker_obj.type)
		else:
			debug_text += "  Tracker Found: NO\n"
		
		if log_file and frame_count % 60 == 0:
			log_file.store_line("RIGHT Controller:")
			log_file.store_line("  Tracker: %s" % right_controller.tracker)
			log_file.store_line("  Pose: %s" % right_controller.pose)
			log_file.store_line("  Active: %s" % str(active))
			log_file.store_line("  Has Tracking: %s" % str(has_tracking))
			log_file.store_line("  Grip: %.2f" % grip)
			log_file.store_line("  Trigger: %.2f" % trigger)
			log_file.store_line("  Primary Vec2: (%.2f, %.2f)" % [primary_vec.x, primary_vec.y])
	else:
		debug_text += "RIGHT: NO CONTROLLER\n"
	
	if log_file and frame_count % 60 == 0:
		log_file.flush()
	
	text = debug_text

func _exit_tree():
	if log_file:
		log_file.store_line("\n=== VR Debug Log Ended ===")
		log_file.close()

