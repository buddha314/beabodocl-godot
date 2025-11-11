# Beabodocl VR Client - Godot 4.5.1

This directory contains the Godot VR client project for beabodocl.

## Project Status

✅ **VR Configuration Complete** - Ready for Quest 3 deployment testing

### What's Configured

- **Godot Version**: 4.5.1 Stable (Forward+ renderer)
- **OpenXR**: Enabled with Quest 3 optimizations
- **VR Scene**: Basic scene with XROrigin3D, camera, and controllers
- **Performance**: Foveated rendering (level 3, dynamic)

## Files

### Core Files
- `project.godot` - Project settings with OpenXR configuration
- `main.tscn` - Main VR scene with XROrigin3D structure
- `vr_startup.gd` - OpenXR initialization script
- `openxr_action_map.tres` - Controller action mapping (empty template)

### Scene Structure

```
Main (Node3D)
├─ XROrigin3D
│  ├─ XRCamera3D (1.7m height - standing VR)
│  ├─ LeftHand (XRController3D)
│  └─ RightHand (XRController3D)
└─ Environment
   ├─ DirectionalLight3D
   ├─ Floor (10x10 mesh)
   └─ WorldEnvironment
```

## OpenXR Settings

Configured in `project.godot`:

```ini
[xr]
openxr/enabled=true
openxr/submit_depth_buffer=true        # Required for Quest 3
openxr/reference_space=1               # Stage (standing VR)
openxr/foveation_level=3               # Maximum foveation
openxr/foveation_dynamic=true          # Dynamic performance optimization
```

## Next Steps

1. **Test on Quest 3**
   - Configure Android export in Godot
   - Build APK and deploy to Quest 3
   - Verify 90 FPS performance
   - Test controller tracking

2. **Expand VR Scene**
   - Add controller hand models
   - Implement locomotion system
   - Add interaction system (ray-based)

3. **API Integration**
   - Create HTTP client for babocument API
   - Test connectivity to backend

## Development

### Opening in Godot

1. Launch Godot 4.5.1
2. Click "Import"
3. Select `project.godot` in this directory
4. Click "Import & Edit"

### Testing VR (Desktop)

Requires SteamVR or similar OpenXR runtime:

1. Start SteamVR
2. Press F5 in Godot to run project
3. Put on VR headset

### Building for Quest 3

See `../VR_SETUP.md` for complete Quest 3 deployment instructions.

## Performance Targets

- **Target FPS**: 90 FPS (Quest 3 native)
- **Minimum FPS**: 72 FPS
- **Draw Calls**: <150-200
- **Triangles**: <200K-300K per frame
- **Texture Memory**: <768 MB
- **Total Memory**: <3 GB

## References

- Parent project: `../README.md`
- VR setup guide: `../VR_SETUP.md`
- Project plan: `../PLAN.md`
- Backend API: https://github.com/buddha314/babocument

---

**Last Updated**: November 10, 2025
**Godot Version**: 4.5.1 Stable
**Target Hardware**: Meta Quest 3
