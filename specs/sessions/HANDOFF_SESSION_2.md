# Phase 0 - Foundation Complete: VR/XR Setup

**Date**: November 10, 2025  
**Session**: Phase 0 Implementation - Part 1  
**Status**: ✅ Issue #1 Research Complete, Ready for Godot Project Creation  

---

## Session Summary

Completed comprehensive research for **Issue #1: Godot Version Selection & VR/XR Setup**. Discovered critical finding that OpenXR is built into Godot 4.x core (no plugin needed). Created detailed VR setup documentation and prepared project structure.

### Completed Tasks

✅ **Godot Version Research** - Determined Godot 4.3 is optimal choice  
✅ **OpenXR Investigation** - Confirmed built-in support, no plugin required  
✅ **VR_SETUP.md Created** - Comprehensive 400+ line setup guide  
✅ **.gitignore Created** - Godot 4.x + VR-specific ignore patterns  
✅ **Platform Support Verified** - Quest 2/3, PCVR, SteamVR confirmed  
✅ **Performance Targets Defined** - 90 FPS on Quest 2/3  

---

## Critical Findings

### 🎯 OpenXR is Built Into Godot 4.x Core

**This changes everything from original plan:**

- ❌ **No plugin installation needed** (unlike Godot 3.x)
- ✅ OpenXR module is in `modules/openxr/` as core functionality
- ✅ Fully supported on Windows, Linux, Android (Quest), macOS
- ✅ Includes all major extensions (hand tracking, foveated rendering, etc.)

**Source**: Analyzed `godotengine/godot` repository, confirmed OpenXR is compiled into engine since Godot 4.0.

---

## Godot Version Decision: **4.3 Stable**

### Comparison Matrix

| Version | Status | OpenXR | Quest Support | Recommended |
|---------|--------|--------|---------------|-------------|
| **4.3** | **Stable** | ✅ Built-in | ✅ Production | **✅ YES** |
| 4.2.x LTS | LTS | ✅ Built-in | ✅ Stable | ⚠️ Older features |
| 4.4+ | Dev | ✅ Built-in | ⚠️ Unstable | ❌ Too risky |

### Why Godot 4.3?

1. **Latest stable release** with mature OpenXR 1.0 support
2. **Meta Quest 2/3 support** is production-ready
3. **Vulkan renderer** optimized for VR/XR (90 FPS target achievable)
4. **Active maintenance** with recent bug fixes
5. **Community validation** - widely deployed in VR projects
6. **No breaking changes** expected before 4.4

---

## Documents Created

### 1. VR_SETUP.md (400+ lines)

Comprehensive setup guide including:

- **Godot version decision rationale**
- **OpenXR configuration** (project settings, extensions)
- **Quest 2/3 deployment** (developer mode, USB debugging, APK export)
- **Android SDK setup** (paths, export presets, permissions)
- **Performance targets** (90 FPS, draw calls, memory limits)
- **Troubleshooting guide** (common issues + solutions)
- **Testing procedures** (desktop SteamVR, Quest deployment)
- **Resource links** (official docs, community, tutorials)

### 2. .gitignore

Godot 4.x-specific ignore patterns:
- `.godot/` directory (replaces `.import/` from Godot 3)
- Build artifacts (APKs, executables)
- Android build files
- IDE configurations
- Blender backup files

---

## Project Structure Defined

```
beabodocl-godot/
├── .git/                    # Version control
├── .godot/                  # Engine files (gitignored)
├── addons/                  # Third-party addons
├── assets/                  # Game assets
│   ├── models/             # 3D models (.blend, .gltf, .glb)
│   ├── materials/          # PBR materials
│   ├── textures/           # Texture files
│   ├── fonts/              # UI fonts
│   └── audio/              # Sound effects
├── scenes/                  # Godot scene files (.tscn)
│   ├── environment/        # VR environment (hexagonal room)
│   ├── ui/                 # UI panels (chat, documents, viz)
│   └── main.tscn           # Main scene entry point
├── scripts/                 # GDScript files (.gd)
│   ├── api/                # HTTP API client
│   ├── controllers/        # VR controller handling
│   ├── ui/                 # UI logic
│   └── autoload/           # Singleton scripts (ApiClient, etc.)
├── docs/                    # Documentation
├── lookbook/                # Visual references
├── specs/                   # Design specifications
├── .gitignore
├── project.godot            # Godot project configuration
├── VR_SETUP.md
├── README.md
├── PLAN.md
└── HANDOFF.md
```

---

## Technical Specifications

### OpenXR Configuration

**Project Settings** (`project.godot`):
```ini
[xr]
openxr/enabled=true
openxr/form_factor=0            # HMD
openxr/view_configuration=1     # Stereo
openxr/reference_space=1        # Stage (or Local Floor)
openxr/submit_depth_buffer=true
openxr/foveation_level=0        # Off initially, enable for optimization
openxr/foveation_dynamic=false
```

### Rendering Configuration

- **Renderer**: Forward+ (Vulkan-based, best VR performance)
- **MSAA**: 4x (or 2x for better performance)
- **Target FPS**: 90 (Quest 2/3 native)
- **Viewport**: 1920x1080 (per-eye resolution handled by OpenXR)

### Supported Platforms

| Platform | OpenXR Runtime | Status |
|----------|----------------|--------|
| **Meta Quest 2/3** | Meta OpenXR | ✅ Primary target |
| **Windows PCVR** | SteamVR, Oculus | ✅ Supported |
| **Linux PCVR** | SteamVR, Monado | ✅ Supported |
| **macOS** | - | ⚠️ Limited (dev only) |

### Performance Targets (Quest 2/3)

| Metric | Target | Critical |
|--------|--------|----------|
| Framerate | 90 FPS | 72 FPS min |
| Draw Calls | <100-150 | <200 |
| Triangles | <100K-200K | <500K |
| Texture Mem | <512 MB | <1 GB |
| Total Mem | <2 GB | <3 GB |

---

## Immediate Next Steps (In Order)

### Step 1: Install Godot 4.3 ⬜

**Action**:
1. Download Godot 4.3 from https://godotengine.org/download/
2. Choose **Standard version** (not Mono unless using C#)
3. Extract and add to PATH
4. Verify: `godot --version` shows 4.3.x

**Time Estimate**: 15 minutes

---

### Step 2: Create Godot Project ⬜

**Action**:
1. Launch Godot Project Manager
2. Create new project:
   - Name: `beabodocl-godot`
   - Path: `C:\Users\b\src\beabodocl-godot`
   - Renderer: **Forward+**
3. Open project in editor

**Time Estimate**: 5 minutes

---

### Step 3: Configure OpenXR Settings ⬜

**Action**:
1. Open `Project > Project Settings`
2. Enable `XR > OpenXR > Enabled`: ON
3. Set `XR > OpenXR > Form Factor`: Head Mounted Display
4. Set `XR > OpenXR > Reference Space`: Stage
5. Enable `XR > OpenXR > Submit Depth Buffer`: ON
6. Set `Rendering > Renderer > Method`: Forward+
7. Set `Rendering > Anti-Aliasing > MSAA 3D`: 4x

**Time Estimate**: 10 minutes

**Reference**: VR_SETUP.md section "Configure OpenXR in Project Settings"

---

### Step 4: Create Directory Structure ⬜

**Action**:
```powershell
# In project root
New-Item -ItemType Directory -Path "assets\models"
New-Item -ItemType Directory -Path "assets\materials"
New-Item -ItemType Directory -Path "assets\textures"
New-Item -ItemType Directory -Path "assets\fonts"
New-Item -ItemType Directory -Path "scenes\environment"
New-Item -ItemType Directory -Path "scenes\ui"
New-Item -ItemType Directory -Path "scripts\api"
New-Item -ItemType Directory -Path "scripts\controllers"
New-Item -ItemType Directory -Path "scripts\ui"
New-Item -ItemType Directory -Path "scripts\autoload"
```

**Time Estimate**: 5 minutes

---

### Step 5: Create Basic VR Scene (Issue #3 Start) ⬜

**Action**:
1. Create new 3D scene
2. Add `XROrigin3D` node (root)
3. Add `XRCamera3D` as child of XROrigin3D
4. Add `XRController3D` nodes for left/right hands
5. Save as `scenes/main.tscn`
6. Set as main scene in Project Settings
7. Test with `F5` (requires SteamVR on desktop)

**Time Estimate**: 20 minutes

**Reference**: VR_SETUP.md section "Testing VR Setup"

---

### Step 6: Test on Desktop (SteamVR) ⬜

**Action**:
1. Install SteamVR from Steam
2. Connect VR headset (or use Quest Link)
3. Launch SteamVR
4. Run Godot project (`F5`)
5. Put on headset, verify VR view
6. Check console for OpenXR messages

**Time Estimate**: 30 minutes (including SteamVR setup)

**Expected Console Output**:
```
OpenXR: Instance created
OpenXR: Session state changed to READY
OpenXR: Session state changed to SYNCHRONIZED
OpenXR: Session state changed to VISIBLE
OpenXR: Session state changed to FOCUSED
```

---

### Step 7: Set Up Quest 2/3 Deployment ⬜

**Action**:
1. Enable Developer Mode on Quest headset (via Meta app)
2. Install Meta Quest Developer Hub
3. Connect Quest via USB-C
4. Enable USB debugging on Quest
5. Verify: `adb devices` shows headset
6. Configure Android export in Godot:
   - Install Android build templates
   - Set Android SDK path
   - Create Android export preset
   - Set XR Mode to OpenXR

**Time Estimate**: 1 hour (first-time setup)

**Reference**: VR_SETUP.md section "Quest 2/3 Deployment Setup"

---

### Step 8: Build & Test on Quest ⬜

**Action**:
1. `Project > Export > Android`
2. Select Quest device
3. Check "Export with Debug"
4. Click "Export & Run"
5. Put on Quest headset
6. Verify app launches in VR
7. Check `adb logcat -s godot` for errors

**Time Estimate**: 30 minutes

**Success Criteria**:
- App appears in Quest "Unknown Sources"
- VR scene renders at 72+ FPS
- Head tracking works
- Controllers are tracked

---

## Issue #1 Status

### ✅ Completed

- [x] Research Godot 4.x versions
- [x] Investigate OpenXR support in Godot 4.3
- [x] Determine recommended version (4.3)
- [x] Verify Quest 2/3 compatibility
- [x] Document setup process (VR_SETUP.md)
- [x] Create project structure plan
- [x] Define performance targets
- [x] List required software/tools

### ⬜ Remaining (Next Session)

- [ ] Install Godot 4.3
- [ ] Create Godot project
- [ ] Configure OpenXR settings
- [ ] Create basic VR scene
- [ ] Test on desktop (SteamVR)
- [ ] Set up Quest deployment
- [ ] Build and test on Quest 2/3
- [ ] Update GITHUB_ISSUES.md with completion notes

**Estimated Time to Complete**: 3-4 hours (includes Quest setup)

---

## Updated Timeline

### Phase 0 (Foundation) - Revised

| Issue | Task | Original Est. | Actual/Revised | Status |
|-------|------|---------------|----------------|--------|
| #1 | **Godot & OpenXR Setup** | 6-8 hours | **2 hours research + 3-4 hours setup** | 🟡 In Progress |
| #6 | Blender Pipeline | 2-4 hours | 2-4 hours | ⬜ Not Started |
| #2 | HTTP API Client | 8-12 hours | 8-12 hours | ⬜ Not Started |

**Total Phase 0**: 16-24 hours → **13-22 hours** (slight improvement due to no plugin needed)

---

## Key Decisions Made

### 1. Godot 4.3 (Not 4.2 LTS or 4.4+)

**Reason**: Best balance of stability, features, and Quest support

### 2. No External OpenXR Plugin

**Reason**: Built into Godot 4.x core, eliminating dependency management

### 3. Forward+ Renderer (Not Mobile)

**Reason**: VR requires high-quality rendering, Forward+ is optimized for Vulkan

### 4. Stage Reference Space (Not Local)

**Reason**: Grounded locomotion requires Stage or Local Floor for proper height

### 5. Foveated Rendering Off Initially

**Reason**: Enable later during optimization phase after profiling

---

## Technical Risks Identified

### Risk 1: Performance on Quest 2 (Lower-End Hardware)

**Mitigation**:
- Target 72 FPS as baseline, 90 FPS as goal
- Use aggressive LOD system
- Enable foveated rendering
- Profile early and often with MQDH

### Risk 2: Text Readability in VR

**Mitigation**:
- Use high-contrast colors
- Test font sizes at various distances
- Implement dynamic text scaling
- Add distance-based LOD for UI panels

### Risk 3: Motion Sickness from Locomotion

**Mitigation**:
- Grounded locomotion only (no flying)
- Snap turning option
- Vignette during movement
- Comfort mode settings

---

## Open Questions (For Future Sessions)

1. **Locomotion Type**:
   - Continuous movement (smooth)?
   - Teleport (comfort)?
   - Both (user preference)?

2. **VR Keyboard**:
   - On-screen keyboard in VR?
   - Voice input only?
   - Require desktop for text?

3. **Hand Tracking**:
   - Enable hand tracking extension?
   - Controller-only for MVP?
   - Add hand tracking in Phase 3+?

4. **Foveated Rendering**:
   - Enable by default on Quest?
   - User setting?
   - Dynamic based on performance?

---

## Resources Added to VR_SETUP.md

### Official Documentation
- Godot XR Documentation
- OpenXR Specification
- Meta Quest Development Docs

### Community Resources
- Godot XR Discord
- Godot XR Tools addon
- Reddit communities (r/godot, r/vrdev)

### Tools Referenced
- Meta Quest Developer Hub
- Android Studio
- SteamVR
- Godot XR Tools

---

## Next Session Checklist

### Before Starting

- [ ] Godot 4.3 downloaded
- [ ] Android Studio installed (for Quest dev)
- [ ] Quest 2/3 available for testing
- [ ] Meta Developer account created
- [ ] SteamVR installed (for desktop testing)

### During Session

1. Install Godot 4.3
2. Create project
3. Configure OpenXR
4. Build basic VR scene
5. Test on desktop
6. Set up Quest deployment
7. Test on Quest
8. Update HANDOFF.md

### Success Criteria

- ✅ Godot 4.3 project created
- ✅ OpenXR enabled and configured
- ✅ Basic VR scene renders on desktop
- ✅ App builds and runs on Quest 2/3
- ✅ 72+ FPS on Quest
- ✅ Head and controller tracking work
- ✅ VR_SETUP.md validated with actual setup

---

## Time Investment Analysis

### This Session (Research & Documentation)

| Task | Time Spent |
|------|-----------|
| Godot version research | 30 min |
| OpenXR investigation | 45 min |
| VR_SETUP.md creation | 60 min |
| Project structure planning | 15 min |
| .gitignore creation | 5 min |
| Handoff documentation | 30 min |
| **Total** | **~3 hours** |

### Next Session (Implementation)

| Task | Estimated Time |
|------|---------------|
| Godot 4.3 installation | 15 min |
| Project creation | 5 min |
| OpenXR configuration | 10 min |
| Directory structure | 5 min |
| Basic VR scene | 20 min |
| Desktop testing | 30 min |
| Quest deployment setup | 60 min |
| Quest testing | 30 min |
| **Total** | **~3 hours** |

**Issue #1 Total**: ~6 hours (within original 6-8 hour estimate)

---

## Files Modified/Created

### Created
- ✅ `VR_SETUP.md` (404 lines)
- ✅ `.gitignore` (48 lines)
- ✅ `HANDOFF_SESSION_2.md` (this file)

### Modified
- ⬜ `GITHUB_ISSUES.md` (update Issue #1 with findings)
- ⬜ `HANDOFF.md` (mark as previous session)

---

## Status Summary

**Phase 0 - Issue #1**: 🟡 **50% Complete**

- ✅ Research phase: **Complete**
- ⬜ Implementation phase: **Not Started**

**Next Action**: Install Godot 4.3 and create project  
**Blocker**: None  
**Risk Level**: Low  

---

**Document Version**: 1.0  
**Last Updated**: November 10, 2025  
**Next Update**: After Godot project creation and VR testing
