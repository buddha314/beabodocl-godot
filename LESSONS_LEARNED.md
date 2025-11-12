# Lessons Learned - Beabodocl Godot VR

## Critical Development Principles

### ⭐ ALWAYS Check for Godot Packages Before Building Subsystems

**What Happened:**
We spent hours implementing custom VR locomotion (movement and turning) from scratch, dealing with:
- OpenXR action map configuration complexity
- Controller input reading issues
- Physics rate synchronization
- Session initialization timing
- Default action map vs custom action maps

**What We Should Have Done:**
Check for existing Godot packages FIRST. The official Godot documentation explicitly recommends using [Godot XR Tools](https://github.com/GodotVR/godot-xr-tools) for VR mechanics.

**Why Godot XR Tools Would Have Been Better:**
- ✅ Pre-built movement components (`movement_direct.tscn`, `movement_turn.tscn`)
- ✅ Proper action map already configured
- ✅ Handles roomscale tracking edge cases
- ✅ PlayerBody node that manages physics correctly
- ✅ Tested across multiple XR platforms and runtimes
- ✅ Handles comfort settings (snap turn, smooth turn, strafe options)
- ✅ Includes hand models, teleportation, climbing, and more

**Time Impact:**
- Custom implementation: ~4-6 hours of debugging action maps, controller input, and physics
- Using XR Tools: ~15 minutes to install and configure pre-built components

**The Rule:**
Before implementing ANY major subsystem:
1. Search Godot Asset Library
2. Check official Godot documentation for recommendations
3. Search GitHub for `godot-[feature-name]`
4. Check XR Tools specifically for VR mechanics
5. Only build custom if no suitable package exists OR you have very specific requirements

**Resources to Check:**
- [Godot Asset Library](https://godotengine.org/asset-library/asset)
- [Godot XR Tools](https://github.com/GodotVR/godot-xr-tools) - VR mechanics
- [Awesome Godot](https://github.com/godotengine/awesome-godot) - Curated list
- Official Godot tutorials often mention recommended packages

## Other Lessons

### Blender Asset Pipeline
- **Lesson**: Use Edit Mode scaling for thin objects (walls, panels) to avoid transform normalization
- **Source**: `BLENDER_ASSET_PIPELINE.md`
- **Impact**: Prevents dimension corruption during export

### VR Startup Script
- **Lesson**: Must disable v-sync and match physics tick rate to headset refresh rate
- **Source**: Official Godot "Better XR Start Script" documentation
- **Impact**: Critical for controller responsiveness and preventing stuttering

### Wall Orientation
- **Lesson**: In VR rooms, walls must face inward toward center for proper texture visibility
- **Source**: Debug sessions 6-7
- **Impact**: User can't see wall textures if facing wrong direction

---

**Last Updated**: November 11, 2025
