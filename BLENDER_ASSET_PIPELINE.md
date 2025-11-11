# Blender Asset Pipeline - Beabodocl Godot

**Version**: 1.1  
**Date**: November 11, 2025  
**Status**: Established Pipeline for Phase 1+

---

## 🔴 CRITICAL: Asset Orientation Standard

**All Blender assets MUST follow Z-Forward (Godot-Aligned) convention**

### Blender Modeling Requirements

When creating any asset in Blender, model it with this orientation:

- **Forward face**: **-Z axis** (pointing toward you in Front view, Numpad 1)
- **Width/Horizontal**: **+X axis** (left/right)
- **Height/Vertical**: **+Y axis** (up/down in Blender, becomes Y-up in Godot)

### Visual Guide

**In Blender (where you model):**
```
      Z (Up in Blender)
      |
      |
      +---- X (Width/Right)
     /
    /
   Y (Forward in Blender default)
```

**For Godot Export (what we need):**
```
      Y (Up in Godot)
      |
      |
      +---- X (Width/Right - same as Blender)
     /
    /
   Z (Forward in Godot, -Z specifically)
```

**CRITICAL: Model with front face toward -Y in Blender**
- When you export with "-Z Forward" setting, Blender's -Y becomes Godot's -Z
- Your asset's front should face **toward you** when in **Front View (Numpad 1)** in Blender
- This is the **-Y direction** in Blender's coordinate system

### Using Blender's Orientation Widget

**Top-right corner of 3D Viewport:**
- The small axis gizmo shows X (red), Y (green), Z (blue)
- When modeling, switch to **Front View (Numpad 1)**
- The widget should show **-Y pointing toward you**
- Your asset's front face should point in this direction

**How to verify:**
1. Press **Numpad 1** to enter Front View
2. Look at orientation widget in top-right
3. Widget should display **"-Y"** or the Y-axis (green) pointing toward you
4. Model your asset so the **front face points toward you** (toward -Y)
5. Width should span left-right (X-axis, red)
6. Height should span up-down (Z-axis, blue, becomes Y in Godot)

**Quick Check:**
- Front view (Numpad 1) → Front of asset faces you → This is **-Y in Blender** → Becomes **-Z in Godot** ✅
- Right view (Numpad 3) → Left side of asset faces you → Width along X-axis ✅
- Top view (Numpad 7) → Top of asset faces you → Height along Z-axis ✅

### Why Z-Forward?

1. ✅ **Matches Godot's coordinate system** (-Z is forward in Godot)
2. ✅ **Eliminates rotation translation** (no 90° offset needed)
3. ✅ **Simplifies positioning code** (predictable rotations)
4. ✅ **Industry standard** (Unity, Unreal also use Z-forward)
5. ✅ **Easier debugging** (what you see in Blender matches Godot)

### Verification Before Export

In Blender, before exporting:

1. Switch to **Front View**
   - **With numpad**: Press `Numpad 1`
   - **Without numpad**: Press `~` (tilde, top-left), then select "Front" from pie menu
   - Or use **View menu → Viewpoint → Front**
2. Check orientation widget (top-right): Should show **"-Y"** pointing toward you
3. The **front face** of your asset should be facing you (**-Y direction in Blender**)
4. Width should span **left-right** (X-axis, red in widget)
5. Height should span **up-down** (Z-axis, blue in widget, becomes Y in Godot)
6. **CRITICAL**: Apply all transforms to freeze position/rotation/scale
   - Select the object
   - Press `Ctrl+A` → Select **"All Transforms"**
   - Or use **Object menu → Apply → All Transforms**
   - This bakes rotation into the mesh geometry so it exports correctly

**What the export does:**
- Blender's **-Y** (front in Front View) → becomes Godot's **-Z** (forward)
- Blender's **X** (width) → stays Godot's **X** (width)
- Blender's **Z** (height) → becomes Godot's **Y** (height)

### Common Mistakes to Avoid

❌ **WRONG**: Modeling wide along Y-axis (Blender default habit)  
❌ **WRONG**: Using +Z forward instead of -Z  
❌ **WRONG**: Forgetting to apply rotation before export

✅ **CORRECT**: Model front-facing in Front view (-Z)  
✅ **CORRECT**: Width along X-axis  
✅ **CORRECT**: Apply all transforms (Ctrl+A) before export

---

## Philosophy: Blender-First Workflow

**CRITICAL**: This project uses a **Blender-first asset creation workflow**, NOT procedural generation.

### Why Blender-First?

1. **Artistic Control**: Precise control over cyberpunk-solarpunk hybrid aesthetic
2. **Material Quality**: PBR materials authored with full texture control
3. **Iteration Speed**: Faster to model/texture in Blender than code procedurally
4. **Reusability**: Assets can be reused across scenes
5. **Collaboration**: Artists can work in familiar tools
6. **Quality**: Hand-crafted assets match the design vision better

---

## File Format Decision: Use .gltf Export Workflow

**Recommendation**: Export `.gltf` files from Blender

### Why .gltf Over .blend Direct Import?

| Feature | .blend (Direct) | .gltf/.glb (Export) |
|---------|----------------|---------------------|
| **Workflow** | Single file, auto-updates | Manual export step |
| **Godot Path Issues** | May fail with Blender Launcher paths | Always works |
| **Materials** | Full Blender materials preserved | Standard PBR (reliable) |
| **Iteration** | Save in Blender → auto-reimport | Export → Import (one extra step) |
| **Version Control** | One source file | Source + export = 2 files |
| **File Size** | Larger (includes history) | Smaller (optimized) |
| **Godot Support** | Native but path-dependent | Standard format (no config needed) |

**Decision**: Use `.gltf` export workflow to avoid Blender path configuration issues. Keep `.blend` source files in `blender_source/`, export to `.gltf` in `client/assets/models/`.

**Note**: Direct `.blend` import requires Godot to locate the Blender executable, which can fail with non-standard installations (Blender Launcher, portable versions, hidden AppData folders).

### When to Use Each Format

- **Development (Phase 1-4)**: `.gltf` files (exported from Blender)
  - Reliable import (no path configuration needed)
  - Standard PBR materials
  - Works with any Blender installation
  
- **Production (Final Builds)**: `.gltf` or `.glb`
  - Smaller file sizes
  - Faster loading
  - Platform optimization
  - `.glb` = single binary file (easier to manage)

---

## Directory Structure

```
beabodocl-godot/
├── blender_source/              # Source Blender files (NOT in client/)
│   ├── environments/
│   │   └── hexagonal_room.blend
│   ├── panels/
│   │   ├── chat_panel.blend
│   │   ├── document_panel.blend
│   │   └── viz_panel.blend
│   ├── props/
│   │   └── decorative_elements.blend
│   └── materials/
│       ├── cyberpunk_materials.blend  # Metal, stone, tech
│       └── solarpunk_materials.blend  # Wood, bamboo, living walls
│
└── client/                      # Godot project
    ├── assets/
    │   ├── models/             # Imported/linked .blend files
    │   │   ├── hexagonal_room.blend    # Symlink or copy
    │   │   └── panels.blend
    │   ├── materials/          # Godot material resources (.tres)
    │   ├── textures/           # PBR textures (from Blender or external)
    │   │   ├── cyberpunk/
    │   │   └── solarpunk/
    │   ├── fonts/
    │   └── audio/
    └── scenes/
        ├── environment/
        │   └── hexagonal_room.tscn
        └── ui/
            └── panels.tscn
```

### Key Points

1. **Source Files Outside Godot Project**: Keep `.blend` source files in `blender_source/` to avoid bloating the Godot project
2. **Import to Godot**: Copy or symlink `.blend` files to `client/assets/models/` when ready to use
3. **Textures Separate**: Export textures to `client/assets/textures/` for reuse
4. **Materials**: Create Godot materials in `client/assets/materials/` that reference imported meshes

---

## Workflow

### Step 1: Create in Blender

```
blender_source/environments/hexagonal_room.blend
```

**Best Practices**:
- Use metric units (1 Blender unit = 1 meter in Godot)
- Apply all transforms before export (Location: 0,0,0 / Rotation: 0,0,0 / Scale: 1,1,1)
- Use proper naming conventions (snake_case)
- Organize with collections
- Keep vertex count reasonable for VR (< 100K triangles per room)

**Scale Reference for VR**:
- Player height: 1.7m (XRCamera3D position)
- Room height: 2.5-3m
- Panel height: 1.5-2m (eye level when standing)
- Panel distance: 2-3m from center

### Step 2: Set Up Materials in Blender

Use **PBR Principled BSDF** workflow:
- Base Color
- Metallic
- Roughness
- Normal Map
- Ambient Occlusion (optional)
- Emissive (for holographic/bioluminescent effects)

**Material Naming**:
- `MAT_metal_corrugated`
- `MAT_wood_reclaimed`
- `MAT_glass_holographic`

### Step 3: Export Textures (if external)

If using external texture sources (Poly Haven, ambientCG):

```
client/assets/textures/
├── cyberpunk/
│   ├── metal_corrugated_basecolor.png
│   ├── metal_corrugated_normal.png
│   ├── metal_corrugated_roughness.png
│   └── metal_corrugated_metallic.png
└── solarpunk/
    ├── wood_bamboo_basecolor.png
    └── ...
```

**Recommended Resolution**: 1024x1024 or 2048x2048 (for VR quality)  
**Format**: PNG (lossless) or WebP (compressed)

### Step 4: Export and Import to Godot

**Recommended: Export .gltf from Blender**

1. In Blender: `File → Export → glTF 2.0 (.glb/.gltf)`
2. Export Settings:
   - Format: **glTF Separate** (.gltf + .bin + textures) for development
     - Easier to debug (separate files)
     - Can replace textures individually
   - Or **glTF Binary** (.glb) for production
     - Single file
     - Smaller, faster loading
   - Include: Selected Objects (or check what you need)
   - Transform: 
     - **Forward**: **-Z Forward** ⚠️ CRITICAL
     - **Up**: **+Y Up**
   - Data: 
     - ✓ Mesh
     - ✓ Materials
     - ✓ Cameras (optional)
     - ✓ Punctual Lights (optional)
   - Geometry:
     - ✓ Apply Modifiers
     - ✓ UVs
     - ✓ Normals
     - ✓ Tangents
3. Save to `client/assets/models/hexagonal_room.gltf`
4. Godot auto-imports when you switch back to editor
5. Drag imported scene from FileSystem into your scene tree

**Alternative: Direct .blend Import (If Blender Path Works)**

1. Copy `.blend` file to `client/assets/models/`
2. Godot auto-imports (requires Blender executable configured)
3. If import fails, fall back to `.gltf` export method above

### Step 5: Configure in Godot

1. **Import Settings**: Click imported asset → Import tab
   - **Meshes**: Generate Lightmap UVs (for baked lighting)
   - **Materials**: Import Materials (On)
   - **Animations**: Import if any
   - **Compression**: Compress if needed for Quest 3

2. **Create Scene Instance**: Drag imported scene into a new `.tscn`
3. **Adjust Materials**: Godot may need tweaks for VR optimization
4. **Add Colliders**: Use MeshInstance3D → Mesh → Create Convex Collision Shape

---

## Material Workflow

### Blender → Godot Material Mapping

| Blender (Principled BSDF) | Godot (StandardMaterial3D) |
|---------------------------|----------------------------|
| Base Color | Albedo Texture |
| Metallic | Metallic value/texture |
| Roughness | Roughness value/texture |
| Normal Map | Normal Map texture |
| Emission | Emission texture (for glows) |
| Alpha | Transparency (if enabled) |

### VR Material Best Practices

1. **Avoid Complex Transparency**: Expensive in VR
2. **Use Matte Shaders**: Reduce glare/reflections
3. **Optimize Textures**: Compress for Quest 3 (ASTC format)
4. **Limit Shader Complexity**: Avoid heavy procedural shaders
5. **Bake Lighting**: Use lightmaps for static objects

### Creating Godot Materials

**Option 1: Use Imported Materials**
- Godot creates StandardMaterial3D from Blender materials
- Tweak in Inspector as needed

**Option 2: Create Custom Materials**
```
client/assets/materials/
├── holographic_glass.tres
├── cyberpunk_metal.tres
└── solarpunk_wood.tres
```

In Godot: Right-click → New Resource → StandardMaterial3D → Save as `.tres`

---

## Texture Pipeline

### External Texture Sources

- **Poly Haven**: https://polyhaven.com/ (Free PBR textures)
- **ambientCG**: https://ambientcg.com/ (Free CC0 textures)
- **ComfyUI/Stable Diffusion**: Generate custom textures (AI-assisted)

### Texture Organization

```
client/assets/textures/
├── cyberpunk/
│   ├── metal_corrugated/
│   │   ├── basecolor.png
│   │   ├── normal.png
│   │   ├── roughness.png
│   │   └── metallic.png
│   └── stone_dark/
│       └── ...
└── solarpunk/
    ├── wood_bamboo/
    │   └── ...
    └── moss_living/
        └── ...
```

### Texture Specifications

- **Resolution**: 1024x1024 (minimum), 2048x2048 (recommended), 4096x4096 (max)
- **Format**: PNG (source), WebP or Basis Universal (compressed for Quest)
- **PBR Maps**: Albedo, Normal, Roughness, Metallic, AO (optional)
- **Compression**: Enable in Godot import settings for Quest 3

---

## Performance Optimization for Quest 3

### Polygon Budget

| Asset Type | Target Tris | Max Tris |
|------------|-------------|----------|
| Hexagonal Room | 5K-10K | 20K |
| Single Panel | 2K-5K | 10K |
| Decorative Prop | 500-2K | 5K |
| **Total Scene** | **< 100K** | **< 200K** |

### LOD (Level of Detail)

For complex assets, create 3 LOD levels in Blender:
- LOD0: High detail (close up)
- LOD1: Medium detail (mid-range)
- LOD2: Low detail (far away)

Export as separate collections or models.

### Texture Optimization

1. **Use Power-of-2 Sizes**: 512, 1024, 2048, 4096
2. **Compress in Godot**: ASTC for Quest 3 (set in import settings)
3. **Reduce Channels**: Combine maps (e.g., roughness + metallic in R+G channels)
4. **Mipmaps**: Enable for better performance at distance

---

## Version Control with Blender Files

### .gitignore for Blender

Already configured in project root:
```gitignore
# Blender backup files
*.blend1
*.blend2
*.blend3
```

### Best Practices

1. **Commit Source .blend Files**: Keep in `blender_source/` and commit to Git
2. **Don't Commit Godot Imports**: `.godot/imported/` is gitignored automatically
3. **Commit Exported Assets**: If using .gltf, commit those to `client/assets/models/`
4. **Commit Textures**: Commit textures to `client/assets/textures/`

### Large File Handling

If `.blend` files become large (> 50MB):
- Consider Git LFS (Large File Storage)
- Or keep source files in cloud storage (Google Drive, Dropbox)
- Document external asset locations in README

---

## Naming Conventions

### Blender Files
- `hexagonal_room.blend`
- `chat_panel.blend`
- `cyberpunk_prop_01.blend`

### Blender Objects/Collections
- `ENV_hexagonal_room`
- `PANEL_chat_background`
- `PROP_decorative_plant`

### Materials
- `MAT_metal_corrugated`
- `MAT_glass_holographic`
- `MAT_wood_bamboo`

### Textures
- `metal_corrugated_basecolor.png`
- `wood_bamboo_normal.png`
- `glass_holographic_roughness.png`

---

## Tools & Resources

### Required Software
- **Blender 4.x**: https://www.blender.org/ (Latest LTS or stable)
  - **IMPORTANT**: Godot will prompt for Blender binary location on first `.blend` import
  - Typical locations:
    - Windows (Standard): `C:\Program Files\Blender Foundation\Blender 4.x\blender.exe`
    - Windows (Blender Launcher): `C:\Users\<username>\AppData\Local\Programs\BlenderLauncher\stable\blender-4.x.x-lts.<hash>\blender.exe`
      - Example: `C:\Users\b\AppData\Local\Programs\BlenderLauncher\stable\blender-4.5.4-lts.b3efe983cc58\blender.exe`
    - macOS: `/Applications/Blender.app/Contents/MacOS/Blender`
    - Linux: `/usr/bin/blender` or `/snap/bin/blender`
  - Configure in Godot: `Editor → Editor Settings → FileSystem → Import → Blender → Blender Path`
  - **Workaround for Hidden AppData Folders**: Godot's file picker may not show `AppData`. To set manually:
    1. Open Godot editor settings file: `%APPDATA%\Godot\editor_settings-4.tres`
    2. Add or modify line: `filesystem/import/blender/blender_path = "C:/Users/b/AppData/Local/Programs/BlenderLauncher/stable/blender-4.5.4-lts.b3efe983cc58/blender.exe"`
    3. Use forward slashes `/` in the path
    4. Restart Godot editor
- **Godot 4.5.1**: Already installed

### Optional Tools
- **Substance Painter**: Advanced PBR texturing (paid)
- **GIMP/Krita**: Free texture editing
- **ComfyUI**: AI texture generation

### Learning Resources
- **Blender for VR**: Focus on low-poly modeling, PBR materials
- **Godot Import Documentation**: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes.html
- **VR Asset Optimization**: Keep poly count low, optimize textures

---

## Quick Reference: Create First Asset

### 1. Create Hexagonal Room in Blender

```blender
1. New File → General
2. Delete default cube
3. Add → Mesh → Cylinder
   - Vertices: 6 (hexagon)
   - Radius: 3m
   - Depth: 2.5m
4. Edit Mode → Extrude faces for walls
5. Apply materials (PBR Principled BSDF)
6. Save as: blender_source/environments/hexagonal_room.blend
```

### 2. Import to Godot

```
1. Copy hexagonal_room.blend to client/assets/models/
2. Godot auto-imports
3. Drag imported scene to scenes/environment/
4. Save as hexagonal_room.tscn
5. Add to main.tscn
```

### 3. Test in VR

```
1. Run project (F5)
2. Or deploy to Quest 3 (one-click deploy)
3. Verify scale, materials, performance
```

---

## Next Steps

1. **Create Asset Directories**:
   ```powershell
   New-Item -ItemType Directory -Path blender_source\environments
   New-Item -ItemType Directory -Path blender_source\panels
   New-Item -ItemType Directory -Path blender_source\props
   New-Item -ItemType Directory -Path client\assets\models
   New-Item -ItemType Directory -Path client\assets\textures\cyberpunk
   New-Item -ItemType Directory -Path client\assets\textures\solarpunk
   ```

2. **Begin Hexagonal Room** (Issue #3):
   - Create `hexagonal_room.blend`
   - Model 6-sided room
   - Add placeholder materials
   - Import to Godot and test in VR

3. **Document Any Issues**: Update this guide with learnings

---

**Status**: ✅ Pipeline Established  
**Format Decision**: Use `.blend` files directly for development  
**Directory Structure**: Documented and ready to create  
**Next Action**: Create first asset (hexagonal room)  
**Last Updated**: November 10, 2025
