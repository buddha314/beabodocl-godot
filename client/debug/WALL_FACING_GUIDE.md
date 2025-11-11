# Wall Facing Orientation Guide

**Quick Reference**: How to ensure all walls face the center of your hexagonal room

---

## The Problem

In a hexagonal VR room, walls should face **inward** toward the center so that:
- Interior textures are visible from inside
- Collision detection works correctly
- Visual design appears as intended

If walls face the wrong direction, you'll see:
- Black/backface culled surfaces
- Textures on the outside instead of inside
- Incorrect lighting and shadows

---

## The Solution: `fix_wall_facing.gd`

This debug script automatically:
1. ✅ Checks each wall's forward direction
2. ✅ Calculates if it points toward center (0, 0, 0)
3. ✅ Provides exact rotation corrections
4. ✅ Generates copy-paste Transform3D values

---

## How to Use

### Method 1: Temporary Debug Node (Recommended)

1. Open `client/main.tscn` in Godot
2. Right-click on `Main` node → Add Child Node → Node3D
3. Name it "WallFacingDebug"
4. In Inspector panel, attach script: `res://debug/fix_wall_facing.gd`
5. Press **F5** to run the scene
6. Read output in console (or check `client/debug/wall_facing_debug.log`)
7. Apply recommended fixes (see below)
8. Delete the debug node when done

### Method 2: Already Attached in Scene

The script is already attached to a debug node in `main.tscn`:

```
[node name="WallFacingDebug" type="Node3D" parent="."]
script = ExtResource("X_wall_facing")
```

Just run the scene with **F5** and check the output!

---

## Reading the Output

### ✅ Correct Wall
```
--- Wall2 ---
Position: (3.464, 2.0, 0.0)
Alignment (dot product): 1.000
Angle from center: 0.0°
✓ STATUS: CORRECT - Wall faces inward
```

**Meaning**: This wall is perfectly oriented. No action needed.

---

### ❌ Incorrect Wall
```
--- Wall1 ---
Position: (1.732, 2.0, -3.0)
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

Or copy this transform line into main.tscn:
transform = Transform3D(-0.500000, 0, -0.866025, 0, 1, 0, 0.866025, 0, -0.500000, 1.732, 2.000, -3.000)
```

**Meaning**: This wall faces the wrong direction. Apply one of the fixes below.

---

## How to Fix Incorrect Walls

### Option A: Manual Rotation in Scene Editor

1. In Godot scene tree, navigate to: `Environment → HexagonalRoom → Wall1`
2. In Inspector panel, find **Transform** section
3. Set **Rotation → Y** to the recommended value (e.g., `-1.047` radians)
4. Press **Ctrl+S** to save the scene

### Option B: Copy-Paste Transform (Fastest)

1. Open `client/main.tscn` in a text editor
2. Find the wall node section:
   ```gdscript
   [node name="Wall1" parent="Environment/HexagonalRoom" instance=ExtResource("3_wall")]
   transform = Transform3D(...old values...)
   ```
3. Replace the `transform = ` line with the one from debug output
4. Save the file
5. Reload in Godot

### Option C: Use Rotation Degrees (Most Intuitive)

1. In scene editor, select the wall
2. In Inspector, expand **Transform**
3. Set **Rotation Degrees → Y** to the target value (e.g., `-60.0°`)
4. Save scene

---

## Understanding the Math

### What is "Alignment"?

The **dot product** between:
- Wall's forward direction (where it points)
- Vector from wall to center

**Values**:
- `1.0` = Perfect alignment (wall faces directly at center)
- `0.866` = Within 30° (acceptable)
- `0.0` = Perpendicular (90° off)
- `-1.0` = Facing opposite direction (180° wrong)

### What is "Angle from center"?

The angle between the wall's forward direction and the ideal center-facing direction.

**Threshold**: Walls with angle > 30° are marked as incorrect.

---

## Verification

After applying fixes:

1. **Run the script again** (F5)
2. **Check the summary**:
   ```
   === SUMMARY ===
   Total walls analyzed: 6
   Correctly facing inward: 6
   Incorrectly oriented: 0
   
   ✓ ALL WALLS CORRECTLY ORIENTED
   ```
3. **Visual test**: Load VR scene and verify you can see interior wall textures

---

## Expected Results for Hexagonal Room

For a standard pointy-top hexagonal room with 6 walls:

| Wall | Position | Expected Y Rotation | Facing Angle |
|------|----------|---------------------|--------------|
| Wall1 | (1.732, 2, -3) | -120° | 120° |
| Wall2 | (3.464, 2, 0) | 180° or -180° | 0° |
| Wall3 | (1.732, 2, 3) | 120° | -60° |
| Wall4 | (-1.732, 2, 3) | 60° | -120° |
| Wall5 | (-3.464, 2, 0) | 0° | ±180° |
| Wall6 | (-1.732, 2, -3) | -60° or 300° | 60° |

All should have alignment ≥ 0.866 and angle from center ≤ 30°.

---

## Troubleshooting

### "Could not find HexagonalRoom node"

**Problem**: Script can't locate the room container node.

**Fix**: 
- Check that `main.tscn` has: `Environment → HexagonalRoom`
- Verify the node path in script matches your scene structure
- Edit line in script: `var hex_room = get_node_or_null("/root/Main/Environment/HexagonalRoom")`

### "All walls show INCORRECT"

**Problem**: Walls might be loaded from a misoriented asset file.

**Fix**:
- Check that `wall.glb` follows Z-Forward standard (see `WALL_ORIENTATION_REPORT.md`)
- Verify wall mesh has correct dimensions (width > thickness)
- Run `check_wall_orientation.gd` to validate the asset itself

### Walls still look wrong after correction

**Problem**: The wall asset itself might be oriented incorrectly.

**Fix**:
1. Re-export `wall.glb` from Blender with correct orientation
2. Ensure forward face points toward -Z
3. Apply all transforms in Blender before export (Ctrl+A → All Transforms)
4. Use export settings: Forward = -Z, Up = +Y

---

## Related Documentation

- `README.md` - Overview of all debug scripts
- `WALL_ORIENTATION_REPORT.md` - Analysis of wall.glb asset orientation
- `check_wall_orientation.gd` - Validates the wall.glb asset itself
- `HEXAGON_WALL_PATTERN.md` - Mathematical pattern for wall placement
- `../BLENDER_ASSET_PIPELINE.md` - Asset creation standards

---

## Script Output File

**Location**: `client/debug/wall_facing_debug.log`

This file contains the complete analysis and is readable by:
- AI assistants (for automated debugging)
- External tools
- Version control (to track changes)

**Tip**: Include this log file when reporting issues or asking for help.

---

**Created**: November 11, 2025  
**Last Updated**: November 11, 2025  
**Purpose**: Help developers correctly orient walls in VR room environments
