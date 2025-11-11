extends Node3D

func _ready():
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR interface initialized successfully")
		
		var vp: Viewport = get_viewport()
		vp.use_xr = true
		print("VR viewport enabled")
	else:
		push_error("OpenXR not initialized. Please check VR headset connection.")
