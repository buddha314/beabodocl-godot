# Fix: Blender Transform Application Issue

**Problem**: When applying transforms with extreme scale (0.05 for 0.1m thickness), Blender normalizes the values, causing the 0.1m dimension to become 1m or 2m.

**Root Cause**: You likely scaled a default cube (2m) down on one axis, then applied transforms, which baked the geometry at the wrong size.

---

## ✅ CORRECT Workflow in Blender

### Method 1: Edit Mode Scaling (RECOMMENDED)

This method scales the **mesh vertices** directly, avoiding transform issues:

1. **Add Cube** (or use existing wall)
2. **Enter Edit Mode**: Press `Tab`
3. **Select All**: Press `A`
4. **Scale in Edit Mode**:
   ```
   S, X, 2, Enter     (Scale X to 4m)
   S, Z, 2, Enter     (Scale Z to 4m in Blender = Y in Godot)
   S, Y, 0.05, Enter  (Scale Y to 0.1m = thickness)
   ```
5. **Exit Edit Mode**: Press `Tab`
6. **Verify Object Transforms** (in Properties → Object):
   - Location: 0, 0, 0
   - Rotation: 0°, 0°, 0°
   - Scale: 1, 1, 1 ✅ (Should already be 1,1,1 because we scaled in Edit Mode)

**Why this works**: Scaling in Edit Mode modifies the mesh geometry directly, not the object transform. The object transform stays at Scale 1,1,1.

### Method 2: Dimensions Panel (ALTERNATIVE)

Use Blender's Dimensions property to set exact sizes:

1. **Add Cube** (or use existing wall)
2. **Object Mode** (Tab if needed)
3. **Open Properties Panel**: Press `N` if not visible
4. **Item Tab → Transform → Dimensions**:
   ```
   X: 4 m
   Y: 0.1 m    (this becomes Z thickness in Godot)
   Z: 4 m      (this becomes Y height in Godot)
   ```
5. **Apply Scale**: `Ctrl+A` → Scale
   - This locks the dimensions and sets Scale back to 1,1,1

### Method 3: Plane + Solidify (CLEANEST)

Start with a plane instead of a cube:

1. **Delete default cube**
2. **Add → Mesh → Plane**
3. **Enter Edit Mode**: `Tab`
4. **Select All**: `A`
5. **Scale to 4m × 4m**:
   ```
   S, 2, Enter  (scales to 4m × 4m)
   ```
6. **Exit Edit Mode**: `Tab`
7. **Add Solidify Modifier**:
   - Add Modifier → Generate → Solidify
   - Thickness: **0.05** (this creates 0.1m total thickness, 0.05m on each side)
   - Even Thickness: ✓ Enable
8. **Apply Modifier**: Click "Apply" button
9. **Verify**: Scale should be 1,1,1

---

## 🔍 Verify Before Export

**In Blender, check these before exporting**:

### 1. Object Properties (Press N → Item → Transform)
```
Location: X=0, Y=0, Z=0
Rotation: X=0°, Y=0°, Z=0°
Scale:    X=1, Y=1, Z=1  ⚠️ MUST BE 1,1,1
```

### 2. Dimensions Panel
```
Dimensions:
  X: 4 m     (width)
  Y: 0.1 m   (thickness - becomes Z in Godot)
  Z: 4 m     (height - becomes Y in Godot)
```

### 3. Edit Mode Check
```
1. Tab into Edit Mode
2. Select all (A)
3. Press N → Item → Dimensions
4. Should show same values as Object Mode
```

---

## 🎯 Export Settings (Same as Before)

```
File → Export → glTF 2.0 (.glb/.gltf)

Format: glTF Binary (.glb)

Transform:
  Forward: -Z Forward  ⚠️ CRITICAL
  Up: +Y Up

Geometry:
  ✓ Apply Modifiers
  ✓ UVs
  ✓ Normals
  ✓ Tangents

Save to: client/models/wall.glb
```

---

## 🧪 What You Should See in Godot

After correct export, the AABB should be approximately:

```
Width (X):     4.0 m
Height (Y):    4.0 m
Thickness (Z): 0.1 m
```

**NOT**:
```
Width (X):     2.0 m  ❌
Height (Y):    2.0 m  ❌
Thickness (Z): 2.0 m  ❌ (cube)
```

---

## 📝 Quick Recap: The Problem

**What happened**:
1. Started with cube (2m × 2m × 2m)
2. Scaled in Object Mode: `S, Y, 0.05` → Scale becomes 1, 0.05, 1
3. Applied transforms: Mesh becomes 2m × 0.1m × 2m, Scale resets to 1,1,1
4. But exporter **normalized** or **rounded** the extreme scale

**Solution**: Scale in **Edit Mode** or use **Dimensions** panel to avoid transform complications.

---

**Next Action**: Try Method 1 (Edit Mode Scaling) - it's the most reliable for precise dimensions.
