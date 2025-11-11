# Debug Scripts Documentation

**Location**: `client/debug/`  
**Purpose**: Runtime debugging and geometry inspection tools for Godot VR development

---

## ⚠️ CRITICAL WARNING #1: NEVER USE `log()` AS FUNCTION NAME ⚠️

**GDScript has a built-in `log()` math function (natural logarithm)!**

Using `log()` as a custom function name will cause **parse errors**:
```
ERROR: Invalid argument for "log()" function: argument 1 should be "float" but is "String"
```

### ✅ ALWAYS use `log_msg()` or another name:

```gdscript
# ❌ WRONG - Conflicts with built-in log(x) math function
func log(message: String):
    print(message)

# ✅ CORRECT - Use log_msg() instead
func log_msg(message: String):
    print(message)
```

---

## ⚠️ CRITICAL #2: Debug Script Best Practice for AI Collaboration

**⚠️ ALWAYS write debug output to a log file that the AI agent can read.**

### Why File Output is Essential:
- **AI agents CANNOT see Godot's console output directly**
- Log files enable AI to analyze debug data and provide solutions
- Persistent logs help track issues across sessions
- External tools can parse geometry data from files

### ⚠️ CRITICAL: Don't Trust Script Calculations Without Visual Verification

**Problem**: Debug scripts can calculate orientations incorrectly, leading to wrong recommendations.

**Solution**: ALWAYS create visual debug markers (cubes, arrows, etc.) that can be seen in the 3D viewport or VR.

### Why This Matters:
A script might calculate that a wall "faces the center" based on transform math, but:
- The actual mesh might be backwards (front/back faces reversed in the asset)
- Transform calculations can be correct but the mesh orientation wrong
- Visual inspection immediately reveals the truth

### Example of What Went Wrong:
```gdscript
# ❌ WRONG - Only checked transform math
var wall_forward = -transform.basis.z
var to_center = (center - position).normalized()
var alignment = wall_forward.dot(to_center)
if alignment > 0.866:
    print("✓ CORRECT")  # <-- Could be WRONG!
```

**Problem**: This reported walls as "correct" when they were actually facing outward, because the mesh itself was backwards.

### ✅ CORRECT Debugging Pattern:

```gdscript
# 1. Calculate orientation
var wall_forward = -transform.basis.z
var to_center = (center - position).normalized()
var alignment = wall_forward.dot(to_center)

# 2. CREATE VISUAL DEBUG MARKER
var cube = create_debug_cube()
cube.position = wall.position + (wall_forward * 0.2)
cube.material.albedo_color = Color.GREEN if alignment > 0.866 else Color.RED
env_node.add_child(cube)  # Add to scene so it persists

# 3. Log the data
log_msg("Wall forward: " + str(wall_forward))
log_msg("Debug cube at: " + str(cube.position))

# 4. LET THE HUMAN VERIFY VISUALLY
# Don't blindly apply "corrections" - let user see the cubes and confirm
```

### Lessons Learned from Wall Orientation Debugging:

1. **Visual markers saved the day** - Debug cubes showed immediately which walls were wrong
2. **Script math can lie** - Alignment calculations were "correct" but mesh was backwards
3. **Manual verification is essential** - User had to visually inspect in editor to find true orientation
4. **Don't auto-apply fixes** - Present recommendations, let human verify before applying

### Best Practice Workflow:

1. ✅ Script creates visual debug markers (GREEN/RED cubes)
2. ✅ Script outputs detailed log file with calculations
3. ✅ **Human visually inspects** the 3D scene/VR view
4. ✅ Human confirms which objects need fixing
5. ✅ AI applies corrections based on human's verified feedback
6. ❌ **NEVER** auto-apply transforms without visual verification

### Standard Pattern for ALL Debug Scripts:

```gdscript
extends Node3D

var output_lines = []
var debug_markers = []  # Store visual debug objects

func _ready():
    # Your debug logic here
    log_msg("Debug information: " + str(some_value))
    
    # CREATE VISUAL MARKERS - CRITICAL!
    var marker = create_visual_marker(position, color)
    get_node("/root/Main/Environment").add_child(marker)  # Add to scene
    debug_markers.append(marker)
    
    # ALWAYS write to file at the end
    write_log_file()

func create_visual_marker(pos: Vector3, color: Color) -> MeshInstance3D:
    """Create a visible debug marker in the scene"""
    var mesh_instance = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(0.2, 0.2, 0.2)
    mesh_instance.mesh = box
    
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.emission_enabled = true
    material.emission = color
    material.emission_energy_multiplier = 1.0
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    mesh_instance.material_override = material
    
    mesh_instance.global_position = pos
    return mesh_instance

func log_msg(message: String):
    """Add message to output and print to console"""
    print(message)
    output_lines.append(message)

func write_log_file():
    """Write debug output to file - REQUIRED for AI collaboration"""
    var file_path = "res://debug/your_debug_output.log"
    var file = FileAccess.open(file_path, FileAccess.WRITE)
    
    if file:
        for line in output_lines:
            file.store_line(line)
        file.close()
        
        # Print absolute path so AI knows where to read
        var absolute_path = ProjectSettings.globalize_path(file_path)
        log_msg("\n=== LOG FILE WRITTEN ===")
        log_msg("Absolute path: " + absolute_path)
    else:
        print("ERROR: Could not write log file")
```

### Key Principles:

1. **Visual markers are mandatory** - Cubes, arrows, colored objects that persist in scene
2. **Add markers to Environment node** - Not as children of debug script (so they persist)
3. **Use unshaded emissive materials** - Always visible regardless of lighting
4. **Color-code status** - GREEN = good, RED = needs fix, YELLOW = warning
5. **Log everything** - But don't trust logs alone, require visual confirmation
6. **Present recommendations, don't auto-fix** - Let human verify with their eyes first

### ⚠️ Critical Don'ts:
1. **NEVER use `log()` as a function name** - conflicts with GDScript's built-in logarithm function
2. Use `log_msg()`, `debug_log()`, or `write_debug()` instead
3. Don't rely on console output alone - AI can't see it
4. Don't forget to call `write_log_file()` at the end of `_ready()`

### File Naming Convention:
```
res://debug/collision_debug_output.log
res://debug/geometry_debug_output.log
res://debug/transform_debug_output.log
res://debug/<feature>_debug_output.log
```

All debug logs go in `client/debug/*.log` to keep them organized.

---

## Available Scripts

### 1. `fix_wall_facing.gd` ⭐ **NEW - Wall Orientation Helper**

**Purpose**: Verify and fix wall orientations to ensure they face the center of the room

**Features**:
- Analyzes each wall in the HexagonalRoom
- Calculates if wall faces inward toward center (0, 0, 0)
- **Creates visual debug cubes 0.2m from each wall** 🎯
  - 🟢 **GREEN cube** = Wall facing CORRECT (toward center)
  - 🔴 **RED cube** = Wall facing INCORRECT (away from center)
- Provides specific rotation corrections for misaligned walls
- Outputs corrected Transform3D values ready to paste into scene file
- Generates detailed log file at `res://debug/wall_facing_debug.log`

**Usage**:
1. Attach to any Node3D in your main scene (or create a dedicated node)
2. Run the scene (F5)
3. **Look at the debug cubes in VR/3D view** - they show which walls need fixing
4. Check console output and `client/debug/wall_facing_debug.log` for details
5. Apply recommended rotations to fix any incorrectly oriented walls

**Visual Debugging** 🎯:
The **debug cubes** make it immediately obvious which walls are wrong:
- Stand inside your hexagonal room in VR
- Look for floating cubes near each wall
- GREEN = good, RED = needs 180° rotation
- Much faster than reading console logs!

**What It Checks**:
- Wall's forward direction (-Z axis)
- Vector from wall to room center
- Dot product alignment (1.0 = perfect, <0.866 = needs fix)
- Angle deviation from center-facing

**Example Output**:
```
--- Wall1 ---
Position: (1.732, 2.0, -3.0)
Current rotation (degrees): (0.0, -120.0, 0.0)

Wall forward direction: (0.866, 0.0, 0.5)
Direction to center: (-0.866, 0.0, 0.5)
Alignment (dot product): 0.500
Angle from center: 60.0°

✗ STATUS: INCORRECT - Wall needs adjustment

RECOMMENDED FIX:
  Current Y rotation: -120.0°
  Rotate by: 60.0°
  Target Y rotation: -60.0°

In Godot scene editor:
  Select: Environment/HexagonalRoom/Wall1
  Set rotation Y to: -1.047 radians (-60.0°)
```

**When to Use**:
- ✅ After importing or repositioning walls
- ✅ When walls appear to face outward instead of inward
- ✅ To verify hexagonal room is correctly enclosed
- ✅ During initial room setup
- ✅ After modifying wall transforms manually
- ✅ **Use the debug cubes for instant visual feedback** 🎯

**Pro Tip**: The visual debug cubes are the fastest way to verify orientation. If you see any RED cubes when looking around your room in VR, those walls need to be rotated 180° to face inward.

---

### 2. `debug_geometry_v2.gd` (Recommended)

**Purpose**: Comprehensive geometry and transform logging with file output

**Features**:
- Logs mesh vertices and bounds
- Full transform matrices
- Basis vectors (forward, right, up)
- Wall positions and rotations
- Facing directions and angles
- Outputs to `res://debug_geometry.log`

**Usage**:
1. Attach to any Node3D you want to inspect (e.g., floor mesh instance)
2. Run the scene (F5)
3. Check output in console and `client/debug_geometry.log`

**Example Attachment (in scene file)**:
```gdscript
[ext_resource type="Script" path="res://debug/debug_geometry_v2.gd" id="X"]

[node name="floor" parent="Environment" instance=ExtResource("2_0xm2m")]
script = ExtResource("X")
```

**Output Format**:
```
=== FLOOR GEOMETRY DEBUG ===
Floor position: (0.0, 0.0, 0.0)
Floor rotation (degrees): (0.0, 0.0, 0.0)
Floor transform: ...

=== WALL DEBUG ===
Wall1:
  Position: (1.732, 2.0, -3.0)
  Rotation (degrees): (0.0, -120.0, 0.0)
  Transform matrix: ...
  Facing direction: (0.866025, 0.0, 0.5)
  Facing angle: 120.0°
```

---

### 2. `debug_geometry.gd` (Console Only)

**Purpose**: Basic geometry logging to console only

**Features**:
- Mesh vertices and bounds
- Wall positions and basic rotations
- Console output only (no file)

**Usage**: Same as v2, but output only appears in Godot console

---

### 3. `debug_geometry_file.gd` (Alternative)

**Purpose**: Simplified file output version

**Usage**: Attach to node, outputs to `res://debug_geometry.log`

---

## Quick Start: Fix Wall Orientations

**Problem**: Walls in your hexagonal room don't face the center correctly.

**Solution**: Use `fix_wall_facing.gd` with visual debug cubes 🎯

### Step-by-Step:

1. **Add the script to your scene**:
   ```
   - Open main.tscn
   - Add a new Node3D under Main (or use existing debug node)
   - In Inspector, click script icon
   - Choose res://debug/fix_wall_facing.gd
   ```

2. **Run the scene**:
   ```
   Press F5 to run in VR mode
   ```

3. **Look at the debug cubes** 🎯:
   ```
   - 🟢 GREEN cubes = Wall facing correctly toward center
   - 🔴 RED cubes = Wall facing wrong direction (away from center)
   - Cubes appear 0.2m in front of each wall
   ```

4. **Read the output**:
   ```
   - Check Godot console for immediate results
   - Read detailed log at: client/debug/wall_facing_debug.log
   ```

5. **Apply corrections**:
   ```
   - For each wall marked as INCORRECT (RED cube)
   - Copy the recommended Transform3D line
   - Paste into main.tscn for that wall
   - Or manually adjust rotation Y value in scene editor
   ```

6. **Verify**:
   ```
   - Run scene again (F5)
   - All cubes should now be GREEN ✓
   ```

### Visual Debugging Pro Tip 🎯

The **debug cubes** are the fastest way to check wall orientation:
- Put on your VR headset and run the scene
- Turn around and look at all 6 walls
- Any RED cube = that wall needs fixing
- All GREEN = you're done!

Much faster than reading log files!

### Example Fix Workflow:

**Before** (from log):
```
--- Wall2 ---
✗ STATUS: INCORRECT - Wall needs adjustment
Rotate by: 180.0°
```

**Action**: Update main.tscn:
```gdscript
[node name="Wall2" parent="Environment/HexagonalRoom" instance=ExtResource("3_wall")]
transform = Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, 3.464, 2, 0)
```

**After** (from log):
```
--- Wall2 ---
✓ STATUS: CORRECT - Wall faces inward
```

---

## Common Use Cases

### Inspecting Imported Mesh Geometry

```gdscript
# Attach debug_geometry_v2.gd to imported .glb/.gltf node
# Run scene to see actual vertex positions and bounds
```

**Why**: When you don't know the exact dimensions or orientation of an imported asset.

### Verifying Object Transforms

```gdscript
# Attach to parent of multiple objects (e.g., HexagonalRoom)
# Script automatically finds and logs all children
```

**Why**: To verify rotations, positions, and facing directions are correct.

### Debugging Wall/Panel Placement

```gdscript
# Script specifically looks for "HexagonalRoom" parent node
# Logs all walls with their transforms and facing angles
```

**Why**: Used during hexagonal room construction (see `HEXAGON_WALL_PATTERN.md`).

---

## Script Architecture

### Core Functions

**`_ready()`**
- Entry point, logs main object data
- Waits one frame, then calls `debug_walls()`
- Saves output to file

**`find_mesh_instance(node)`**
- Recursively searches node tree for MeshInstance3D
- Returns first mesh found
- Used to inspect imported scenes

**`debug_walls()`**
- Looks for `HexagonalRoom` and `DebugVertices` nodes
- Logs all children with transforms
- Calculates facing directions

**`log(message)`**
- Prints to console
- Appends to internal buffer for file output

**`save_log_to_file()`**
- Writes buffer to `res://debug_geometry.log`
- Prints absolute path for external tool access

---

## Reading Debug Output from External Tools

### File Path
```
Godot project path: c:\Users\b\src\beabodocl-godot\client\
Debug log: c:\Users\b\src\beabodocl-godot\client\debug_geometry.log
```

### AI Assistant Access
```python
# Can read file directly
read_file("c:\Users\b\src\beabodocl-godot\client\debug_geometry.log")
```

### Why File Output?
- Persistent across sessions
- Can be read by external tools
- Easier to share/analyze than console output
- AI assistants can directly parse geometry data

---

## Customizing Debug Scripts

### Add Custom Logging

```gdscript
func debug_custom_object():
    log("\n=== MY CUSTOM OBJECT ===")
    var obj = get_node("../MyObject")
    log("Position: " + str(obj.global_position))
    log("Custom property: " + str(obj.my_property))
```

### Change Output Path

```gdscript
func save_log_to_file():
    var log_path = "user://my_debug.log"  # User data directory
    # or
    var log_path = "res://logs/debug.log"  # Project subdirectory
```

### Add More Transform Details

```gdscript
# In debug_walls():
log("  Quaternion: " + str(child.quaternion))
log("  Euler angles: " + str(child.rotation))
log("  Local vs Global: " + str(child.position) + " vs " + str(child.global_position))
```

---

## Best Practices

### 1. Temporary Attachment
- Attach debug scripts temporarily
- Remove before final builds
- Don't commit scene files with debug scripts attached

### 2. Performance
- Debug scripts run only in `_ready()`, not every frame
- Minimal performance impact
- Safe to use on complex scenes

### 3. Version Control
- Keep debug scripts in `debug/` directory
- Document what each script does
- Don't version control log files (add to `.gitignore`)

### 4. When to Use
- ✅ When actual geometry differs from expected
- ✅ When rotations/transforms seem incorrect
- ✅ When debugging imported assets
- ✅ When need data for external tools/AI
- ❌ Not needed for regular development

---

## Integration with Development Workflow

### Phase 0-1: Asset Import
1. Import .glb asset from Blender
2. Attach `debug_geometry_v2.gd` to imported node
3. Run scene, check bounds and vertex positions
4. Use data to position other objects correctly

### Phase 1: Room Construction
1. Position walls based on floor geometry
2. Use debug output to verify facing directions
3. Iterate until all walls face inward
4. Document final transforms (see `HEXAGON_WALL_PATTERN.md`)

### Phase 2+: Ongoing Development
1. Keep debug scripts available in `debug/` directory
2. Use when encountering unexpected geometry issues
3. Share log files when collaborating with AI assistants

---

## Related Documentation

- `WALL_FACING_GUIDE.md` - **Step-by-step guide to fix wall orientations** ⭐
- `WALL_ORIENTATION_REPORT.md` - Analysis of wall.glb asset orientation
- `../HEXAGON_WALL_PATTERN.md` - Wall placement pattern using debug output
- `../VR_SETUP.md` - VR configuration and setup
- `../BLENDER_ASSET_PIPELINE.md` - Asset creation workflow

---

## Troubleshooting

### "No MeshInstance3D found"
- Script is attached to wrong node
- Imported scene hasn't fully loaded
- Solution: Attach to parent of .glb import

### "HexagonalRoom node not found"
- Node name doesn't match
- Solution: Check scene hierarchy or modify script

### "Could not write debug log file"
- File permissions issue
- Invalid path
- Solution: Use `user://` path instead of `res://`

### Empty/Incomplete Log
- Script terminated early
- Error in custom logging code
- Solution: Check Godot console for errors

---

**Created**: November 11, 2025  
**Last Updated**: November 11, 2025  
**Maintained By**: Project development team
