# Hexagonal Wall Placement Pattern

**Date**: November 11, 2025  
**Project**: beabodocl-godot VR Client  
**Context**: Hexagonal room environment construction

---

## Problem Solved

How to correctly position and orient 6 walls to enclose a regular hexagonal floor mesh, with walls facing inward toward the center.

## Hexagon Geometry (Actual from floor.glb)

### Floor Bounds
- **Min**: (-3.464, -0.05, -4.0)
- **Max**: (3.464, 0.05, 4.0)
- **Size**: (6.928, 0.1, 8.0)

### Hexagon Type
**Pointy-top hexagon** (vertices at top and bottom, not flat edges)

### Vertex Positions (Clockwise from North)
```
V1: (0, 0, -4)        - North point
V2: (3.464, 0, -2)    - Northeast
V3: (3.464, 0, 2)     - Southeast
V4: (0, 0, 4)         - South point
V5: (-3.464, 0, 2)    - Southwest
V6: (-3.464, 0, -2)   - Northwest
```

## Wall Placement Formula

For a pointy-top hexagon with vertices V1-V6:

### Wall Between Vertices Vn and V(n+1)

1. **Position**: Midpoint of edge
   ```
   position = (Vn + V(n+1)) / 2
   position.y = wall_height  # e.g., 2.0 for standing height
   ```

2. **Rotation**: Calculate angle from center to midpoint, then rotate to face inward
   ```
   edge_vector = V(n+1) - Vn
   edge_angle = atan2(edge_vector.x, edge_vector.z)
   wall_rotation_y = edge_angle + 90° (or π/2 radians)
   ```

3. **Facing Direction**: Should point toward (0, 0, 0) center

## Actual Wall Transforms (Working Solution)

### Wall 1 (V1 → V2)
```gdscript
Position: (1.732, 2, -3)
Rotation: (-120°, 0°) or (240°, 0°)
Transform: Transform3D(-0.5, 0, -0.866025, 0, 1, 0, 0.866025, 0, -0.5, 1.732, 2, -3)
Facing: 120° (southeast toward center)
```

### Wall 2 (V2 → V3)
```gdscript
Position: (3.464, 2, 0)
Rotation: (180°, 0°)
Transform: Transform3D(-1, 0, 0, 0, 1, 0, 0, 0, -1, 3.464, 2, 0)
Facing: 0° (south toward center)
```

### Wall 3 (V3 → V4)
```gdscript
Position: (1.732, 2, 3)
Rotation: (120°, 0°)
Transform: Transform3D(-0.5, 0, 0.866025, 0, 1, 0, -0.866025, 0, -0.5, 1.732, 2, 3)
Facing: -60° (southwest toward center)
```

### Wall 4 (V4 → V5)
```gdscript
Position: (-1.732, 2, 3)
Rotation: (60°, 0°)
Transform: Transform3D(0.5, 0, 0.866025, 0, 1, 0, -0.866025, 0, 0.5, -1.732, 2, 3)
Facing: -120° (northwest toward center)
```

### Wall 5 (V5 → V6)
```gdscript
Position: (-3.464, 2, 0)
Rotation: (0°, 0°)
Transform: Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -3.464, 2, 0)
Facing: -180° (north toward center)
```

### Wall 6 (V6 → V1)
```gdscript
Position: (-1.732, 2, -3)
Rotation: (-60°, 0°) or (300°, 0°)
Transform: Transform3D(0.5, 0, -0.866025, 0, 1, 0, 0.866025, 0, 0.5, -1.732, 2, -3)
Facing: 120° (southeast toward center)
```

## Verification Checklist

✅ **All walls positioned at edge midpoints**  
✅ **All walls facing inward (toward center 0,0,0)**  
✅ **All walls parallel to their respective edges**  
✅ **Walls share corners at vertices (no gaps)**  
✅ **Rotation pattern is symmetrical around hexagon**

## Godot Scene Structure

```
Environment (Node3D)
├── floor (floor.glb instance)
└── HexagonalRoom (Node3D)
    ├── Wall1 (wall.glb instance)
    ├── Wall2 (wall.glb instance)
    ├── Wall3 (wall.glb instance)
    ├── Wall4 (wall.glb instance)
    ├── Wall5 (wall.glb instance)
    └── Wall6 (wall.glb instance)
```

## Key Lessons Learned

### 1. Don't Assume Hexagon Orientation
- Initial assumption was **flat-top** hexagon (horizontal top/bottom edges)
- Actual floor was **pointy-top** hexagon (vertices at top/bottom)
- **Always inspect the actual mesh geometry first**

### 2. Understanding Godot Transforms
- Transform3D is a 3x4 matrix: [basis.x, basis.y, basis.z, origin]
- Basis vectors represent: X (right), Y (up), Z (back/away)
- Forward direction is **-Z** (negative Z axis)
- Rotation around Y-axis affects horizontal orientation

### 3. Debugging Strategy
- Created debug script to print mesh vertices at runtime
- Added visual markers (cubes) at vertices
- Printed wall facing directions and angles
- Iteratively tested and corrected rotations

### 4. Common Pitfalls
- ❌ Walls perpendicular to edges instead of parallel
- ❌ Walls facing outward (convex) instead of inward (concave)
- ❌ Positioning at vertices instead of edge midpoints
- ❌ Assuming coordinate system without verification

### 5. Debugging Tools Created
- `debug_geometry.gd` - Runtime geometry inspector
- Outputs to `res://debug_geometry.log` for external tool access
- Logs: positions, rotations, transforms, facing directions, mesh bounds

## Reusable Pattern for Other Shapes

### For Regular Polygon with N sides:

1. **Identify all N vertices** from mesh bounds or explicit definition
2. **For each edge i** (from vertex i to vertex i+1):
   ```gdscript
   var v1 = vertices[i]
   var v2 = vertices[(i + 1) % N]
   
   # Position at midpoint
   var wall_pos = (v1 + v2) / 2
   wall_pos.y = wall_height
   
   # Calculate edge direction
   var edge_dir = (v2 - v1).normalized()
   
   # Calculate rotation to face inward
   var to_center = -wall_pos.normalized()
   var wall_rotation_y = atan2(-edge_dir.x, -edge_dir.z)
   
   # Create transform
   var transform = Transform3D()
   transform = transform.rotated(Vector3.UP, wall_rotation_y)
   transform.origin = wall_pos
   ```

3. **Verify each wall**:
   - Check facing direction points toward center
   - Verify wall is parallel to its edge
   - Confirm adjacent walls share vertices

## Debug Output Example

```
Wall1:
  Position: (1.732, 2.0, -3.0)
  Rotation (degrees): (0.0, -120.0, 0.0)
  Facing direction: (0.866025, 0.0, 0.5)
  Facing angle: 120° ✅ Points toward center
```

## Files Modified

- `client/main.tscn` - Scene with hexagonal room
- `client/debug_geometry.gd` - Debug logging script
- `HEXAGON_WALL_PATTERN.md` - This documentation

## Next Steps (Post-Completion)

1. ✅ Remove debug vertex markers
2. ✅ Remove debug script from floor
3. ⏳ Add collision shapes to walls
4. ⏳ Position 3 display panels at specific walls
5. ⏳ Implement locomotion system

---

**Status**: ✅ Complete - Hexagonal room fully enclosed  
**Verified**: November 11, 2025  
**Next Priority**: Add display panels at walls 1, 3, 5 (Issue #4)
