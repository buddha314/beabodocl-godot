# Debug Scripts Documentation

**Location**: `client/debug/`  
**Purpose**: Runtime debugging and geometry inspection tools for Godot VR development

---

## Available Scripts

### 1. `debug_geometry_v2.gd` (Recommended)

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
