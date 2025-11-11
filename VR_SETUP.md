# VR/XR Setup Guide - Beabodocl Godot

**Last Updated**: November 10, 2025  
**Status**: Phase 0 - Foundation Setup  

---

## Godot Version Decision: 4.5.1 (Latest Stable)

### Research Summary

After analyzing the Godot repository and OpenXR implementation, here are the key findings:

**✅ CRITICAL: OpenXR is Built Into Godot 4.x Core**
- **No plugin required** for Godot 4.x (unlike Godot 3.x which needed `godot_openxr` plugin)
- OpenXR module is included in `modules/openxr/` as core functionality
- Supports Windows, Linux, Android (Quest), and macOS (limited)

### Version Comparison

| Version | Status | Released | Recommended? | Notes |
|---------|--------|----------|--------------|-------|
| **Godot 4.5.1** | **Stable** | **Oct 15, 2025** | **✅ YES** | Latest stable, best OpenXR, Quest 3 optimizations |
| Godot 4.5 | Stable | Sep 15, 2025 | ⚠️ Use 4.5.1 | Maintenance release available |
| Godot 4.4.1 | Stable | Mar 26, 2025 | ❌ Outdated | Use latest 4.5.1 |
| Godot 4.3 | Stable | Aug 15, 2024 | ❌ Outdated | Missing 4.5 improvements |

### Final Decision: **Godot 4.5.1 Stable**

**Rationale**:
1. **Latest stable release** with all OpenXR improvements through 4.5.1
2. **Meta Quest 3 optimizations** in 4.5 series
3. **Vulkan renderer** fully optimized for VR/XR performance
4. **No external plugins needed** - OpenXR is core
5. **Active maintenance** - released October 2025
6. **Bug fixes** from 4.5 and earlier versions

---

## Supported Platforms

### Desktop Development
- **Windows 10/11** - SteamVR, Oculus Runtime, WMR (DirectX only)
- **Linux** - SteamVR, Monado
- **macOS** - Limited support (use for development, not deployment)

### Target VR Hardware
- ✅ **Meta Quest 3** (primary and only target)
- ⚠️ **PCVR headsets** (SteamVR) - for desktop development/testing only
- ❌ **Quest 2** - Not supported (focus on Quest 3 hardware)
- ❌ **Windows Mixed Reality** - Not supported

---

## Prerequisites

### Required Software

1. **Godot 4.5.1**
   - Download: https://godotengine.org/download/
   - Choose: **Godot Engine - Standard version 4.5.1**
   - For Quest dev: Use the standard version (Mono/.NET not required unless using C#)

2. **Android SDK & NDK** (for Quest deployment)
   - Android Studio: https://developer.android.com/studio
   - SDK Platform: Android 10.0 (API level 29) or higher
   - NDK: r23c or later
   - Build Tools: Latest
   - **Java SDK**: Bundled with Android Studio at `C:\Program Files\Android\Android Studio\jbr`

3. **Godot OpenXR Vendors Plugin** (for Quest 3 support)
   - **Installation Method 1 (Recommended)**: Asset Library
     - In Godot: `AssetLib` tab → Search "OpenXR Vendors"
     - Download "Godot OpenXR Vendors plugin v4"
     - Install to `addons/godotopenxrvendors/`
   - **Installation Method 2**: Manual Download
     - Download from: https://github.com/GodotVR/godot_openxr_vendors/releases
     - Get version 4.1.1-stable (for Godot 4.4+)
     - Extract `assets/addons/godotopenxrvendors/` to your project's `addons/` folder
   - **⚠️ CRITICAL**: You must enable the Meta plugin in export settings (see Quest 3 Deployment Setup)

4. **Meta Quest Developer Hub** (for Quest 3)
   - Download: https://developer.oculus.com/downloads/package/oculus-developer-hub-win/
   - Enables USB debugging, app deployment, and performance profiling

5. **Git** (version control)
   - Download: https://git-scm.com/

### Optional Software

- **Blender 4.x** - For 3D asset creation
- **Visual Studio Code** - For GDScript editing with Godot plugin
- **SteamVR** - For desktop VR testing

---

## Project Setup

### 1. Create Godot Project

```powershell
# Navigate to workspace
cd C:\Users\b\src\beabodocl-godot

# Launch Godot 4.3
# In Godot Project Manager:
# - New Project
# - Project Name: "beabodocl-godot"
# - Project Path: C:\Users\b\src\beabodocl-godot
# - Renderer: Forward+ (for VR performance)
# - Version: Verify you're using 4.5.1
# - Create & Edit
```

### 2. Directory Structure

Create the following folder structure in your project:

```
beabodocl-godot/
├── .git/                    # Git repository
├── .godot/                  # Godot engine files (auto-generated, gitignored)
├── addons/                  # Third-party addons (if any)
├── assets/                  # Game assets
│   ├── models/             # 3D models (.blend, .gltf, .glb)
│   ├── materials/          # PBR materials
│   ├── textures/           # Texture files
│   ├── fonts/              # UI fonts
│   └── audio/              # Sound effects and music
├── scenes/                  # Godot scene files (.tscn)
│   ├── environment/        # VR environment (hexagonal room)
│   ├── ui/                 # UI panels (chat, documents, viz)
│   └── main.tscn           # Main scene entry point
├── scripts/                 # GDScript files (.gd)
│   ├── api/                # HTTP API client
│   ├── controllers/        # VR controller handling
│   ├── ui/                 # UI logic
│   └── autoload/           # Singleton scripts (ApiClient, etc.)
├── docs/                    # Project documentation
├── lookbook/                # Visual references
├── specs/                   # Design specifications
├── .gitignore
├── project.godot            # Godot project configuration
├── README.md
├── PLAN.md
├── HANDOFF.md
└── VR_SETUP.md              # This file
```

### 3. Configure OpenXR in Project Settings

Once Godot project is created:

1. **Open Project Settings** (`Project > Project Settings`)

2. **Enable XR**:
   - Navigate to `XR > OpenXR`
   - **Enable OpenXR**: `ON`
   - **Form Factor**: `Head Mounted Display`
   - **View Configuration**: `Stereo`
   - **Reference Space**: `Stage` (or `Local Floor` for seated experiences)
   - **Submit Depth Buffer**: `ON` (improves performance)
   - ⚠️ **CRITICAL**: Navigate to `XR > Shaders` and set **Enabled**: `ON`
     - This is required for XR-specific shader support
     - Must be set manually in Project Settings UI or in `project.godot`

3. **Configure Rendering**:
   - `Rendering > Renderer > Rendering Method`: `Forward+`
   - `Rendering > Anti-Aliasing > MSAA 3D`: `4x` (or `2x` for better performance)
   - `Rendering > VRS > Mode`: `Texture` (if using foveated rendering)

3b. **⚠️ MANUAL STEP: Add WorldEnvironment to Scene**:
   - In your main VR scene (`main.tscn`), add a `WorldEnvironment` node
   - Click the node and in Inspector, create a new `Environment` resource
   - Configure environment settings:
     - Background Mode: `Sky` or `Color`
     - Ambient Light: Source = `Sky` or `Color`
     - Tonemap: Mode = `Filmic` (better for VR)
     - Glow: Enable if desired (subtle glow for holographic effect)
   - This is required for proper lighting and rendering in VR

4. **Set Target Framerate**:
   - `Application > Run > Max FPS`: `90` (Quest 2/3 native refresh)
   - `Display > Window > Size > Viewport Width`: `1920`
   - `Display > Window > Size > Viewport Height`: `1080`

5. **Android Export Settings** (for Quest):
   - `Application > Config > Name`: `Beabodocl VR`
   - `Application > Config > Package`: `com.beabodocl.vr`
   - `Application > Run > Min SDK`: `29` (Android 10)
   - `Application > Run > Target SDK`: `33` or higher

---

## OpenXR Configuration Details

### Key Project Settings

Add these to `project.godot` (or configure via UI):

```ini
[xr]

openxr/enabled=true
openxr/form_factor=0  # 0 = HMD, 1 = Handheld
openxr/view_configuration=1  # 1 = Stereo
openxr/reference_space=1  # 0 = Local, 1 = Stage, 2 = Local Floor
openxr/submit_depth_buffer=true
openxr/startup_alert=true  # Shows OpenXR errors on startup
openxr/environment_blend_mode=0  # 0 = Opaque (VR), 1 = Additive (AR), 2 = Alpha (passthrough)
openxr/foveation_level=0  # 0 = Off, 1 = Low, 2 = Medium, 3 = High (Quest only)
openxr/foveation_dynamic=false
shaders/enabled=true  # REQUIRED: Enables XR-specific shaders (must be set manually)

[xr/openxr/extensions]

hand_tracking=false  # Enable if using hand tracking
eye_tracking=false   # Enable if using eye tracking
debug_utils=1        # 0 = Disabled, 1 = Error, 2 = Warning, 3 = Info, 4 = Verbose
```

### Supported OpenXR Extensions

Godot 4.5.1 supports these OpenXR extensions (auto-enabled when available):

- **Core**: `XR_KHR_composition_layer_depth`, `XR_KHR_visibility_mask`
- **Quest 3/Meta**: `XR_FB_display_refresh_rate`, `XR_FB_foveation`, `XR_FB_passthrough`
- **Hand Tracking**: `XR_EXT_hand_tracking`, `XR_MSFT_hand_interaction` (Quest 3 native)
- **Eye Tracking**: `XR_EXT_eye_gaze_interaction` (Quest 3 Pro)
- **Spatial Tracking**: `XR_FB_spatial_entity`, `XR_FB_scene`

---

## Quest 3 Deployment Setup

### 1. Enable Developer Mode

1. Open **Meta Quest mobile app**
2. Go to **Menu > Devices > [Your Headset]**
3. Tap **Headset Settings > Developer Mode**
4. Enable **Developer Mode** (requires Meta Developer account)

### 2. Install Meta Quest Developer Hub

1. Download: https://developer.oculus.com/downloads/package/oculus-developer-hub-win/
2. Install and launch
3. Connect Quest via USB-C
4. Enable **USB Debugging** on Quest when prompted
5. Verify connection: Device should show as "Connected" in MQDH

### 3. Configure Android Export in Godot

1. **Install Android Build Template**:
   - `Editor > Manage Export Templates`
   - Download templates for Godot 4.3

2. **Set Up Android SDK Paths**:
   - `Editor > Editor Settings > Export > Android`
   - **Android SDK Path**: `C:\Users\[User]\AppData\Local\Android\Sdk`
   - **Debug Keystore**: Create or use default
   - **Debug Keystore User**: `androiddebugkey`
   - **Debug Keystore Password**: `android`

3. **Create Android Export Preset**:
   - `Project > Export`
   - Add `Android` preset
   - **Name**: `Quest 3` (or your preferred name)
   - **Runnable**: ✓ (enable for one-click deploy)
   - **Use Gradle Build**: ✓ **CRITICAL - Must be enabled**
   - **XR Features > XR Mode**: `OpenXR`
   - **XR Features > Enable Meta Plugin**: ✓ **CRITICAL - Required for Quest 3**
   - **Target**: Meta Quest 3 (ARM64)
   - **OpenXR Features > Hand Tracking**: `Optional` (Quest 3 has improved hand tracking)
   - **OpenXR Features > Passthrough**: `Optional` (if using mixed reality features)
   - **Permissions**: Enable `INTERNET` (for API calls)
   - **Screen > Orientation**: `Landscape`
   - **Architectures**: Enable `arm64-v8a` (Quest 3 uses ARM64)

4. **Test Export**:
   - `Project > Export > Debug`
   - Select Quest device
   - Deploy and test

---

## Remote Deploy from Godot Editor (Recommended for Testing)

**One-Click Deploy to Quest 3**

Instead of manually building and installing APKs, Godot can deploy directly to your connected Quest 3 for faster iteration:

### Setup Remote Deploy

1. **Ensure Quest 3 is connected via USB**:
   - Developer Mode enabled
   - USB debugging authorized
   - Verify with: `adb devices` (should show your Quest)

2. **In Godot Editor**:
   - Click the **Remote Debug** button (next to Play button in top-right)
   - Select your **Android** export preset from dropdown
   - Click **Deploy Remote Debug**
   
3. **What happens**:
   - Godot builds a debug APK automatically
   - Installs it directly to Quest 3 via adb
   - Launches the app immediately
   - Connects remote debugger for live console output
   - You can see errors/print statements in Godot's Output panel

### Using Remote Debug

**Workflow:**
1. Make changes in Godot
2. Click **Deploy Remote Debug** (or press configured hotkey)
3. Godot builds, installs, and launches automatically
4. Put on headset to test
5. Check Godot's **Output** tab for errors/logs
6. Repeat

**Benefits:**
- ✅ Faster than manual export/install
- ✅ Live debugging output in Godot editor
- ✅ Automatic rebuilds include all project files
- ✅ Can set breakpoints and debug GDScript
- ✅ Sees real-time performance metrics

**Note:** The first remote deploy may take longer as it builds everything. Subsequent deploys are incremental and faster.

---

## Testing VR Setup

### Desktop Testing (Before Quest Deployment)

1. **Install SteamVR** (Windows/Linux):
   - Download from Steam
   - Connect PCVR headset (or use Quest Link)
   - Launch SteamVR

2. **Run Godot Project in VR**:
   - Press `F5` (Play) in Godot Editor
   - SteamVR should detect the app
   - Put on headset to verify

3. **Check Console for OpenXR Messages**:
   - Look for: `OpenXR: Instance created`
   - Look for: `OpenXR: Session state changed to READY`
   - Look for: `OpenXR: Session state changed to SYNCHRONIZED`

### Quest 3 Testing

1. **Build APK**:
   - `Project > Export > Android`
   - Check `Export with Debug`
   - Click `Export Project`

2. **Install via MQDH**:
   - Drag APK to MQDH
   - Or use: `adb install -r beabodocl.apk`

3. **Launch on Quest**:
   - Put on headset
   - Go to `Library > Unknown Sources`
   - Launch `Beabodocl VR`

4. **Debug via Logcat**:
   ```powershell
   adb logcat -s godot
   ```

---

## Performance Targets

### Quest 3 Requirements

| Metric | Target | Critical |
|--------|--------|----------|
| **Framerate** | 90 FPS | 72 FPS minimum |
| **Draw Calls** | < 100-150 | < 200 |
| **Triangles** | < 100K-200K | < 500K |
| **Texture Memory** | < 512 MB | < 1 GB |
| **Total Memory** | < 2 GB | < 3 GB |

### Optimization Strategies

1. **Use LOD (Level of Detail)** for 3D models
2. **Enable Foveated Rendering** (Quest native)
3. **Use Occlusion Culling** for hexagonal room
4. **Compress Textures** (ASTC for Quest)
5. **Limit Draw Calls** - batch similar materials
6. **Use Shader Cache** - reduce compilation hitches

---

## Common Issues & Solutions

### Issue: "OpenXR not supported"

**Solution**:
- Check `project.godot` has `xr/openxr/enabled=true`
- Verify you're using Godot 4.3+ (not 3.x)
- On Windows: Install SteamVR or Oculus Runtime
- On Quest: Ensure Developer Mode is enabled

### Issue: Black screen in headset

**Solution**:
- ⚠️ **MOST COMMON**: Check `WorldEnvironment` node has an `Environment` resource attached
  - Select WorldEnvironment node → Inspector → Environment → New Environment
  - Without this, the scene will appear black
- Check XROrigin3D node is in scene
- Verify XRCamera3D is child of XROrigin3D
- Ensure rendering method is Forward+ (not Mobile)
- Check console for OpenXR errors

### Issue: APK won't install on Quest 3

**Solution**:
- Enable USB Debugging on Quest 3
- Check `adb devices` shows headset
- Uninstall old version: `adb uninstall com.beabodocl.vr`
- Verify APK is ARM64 architecture
- Ensure min SDK is 29 (Android 10) or higher

### Issue: Low framerate on Quest 3

**Solution**:
- Enable Foveated Rendering in project settings
- Check MQDH Performance Overlay for bottlenecks
- Quest 3 is more powerful than Quest 2, should hit 90 FPS easier
- Reduce MSAA to 2x if needed (4x should be fine on Quest 3)
- Use simpler shaders (avoid complex transparency)
- Profile GPU/CPU usage

---

## Next Steps

After completing this setup:

1. ✅ **Godot 4.3 installed and configured**
2. ✅ **OpenXR enabled in project settings**
3. ⬜ **Create basic VR scene** (Issue #3)
   - XROrigin3D + XRCamera3D
   - VR controller tracking
   - Grounded locomotion
4. ⬜ **Test on Quest 3 hardware**
5. ⬜ **Implement HTTP API client** (Issue #2)
6. ⬜ **Build hexagonal room environment** (Issue #3)

---

## Resources

### Official Documentation
- **Godot XR Docs**: https://docs.godotengine.org/en/stable/tutorials/xr/index.html
- **OpenXR Spec**: https://registry.khronos.org/OpenXR/specs/1.0/html/xrspec.html
- **Meta Quest Development**: https://developer.oculus.com/documentation/native/

### Community Resources
- **Godot XR Discord**: https://discord.gg/godot (channel: #xr-and-vr)
- **Godot XR Tools** (addon): https://github.com/GodotVR/godot-xr-tools
- **r/godot**: https://reddit.com/r/godot
- **r/vrdev**: https://reddit.com/r/vrdev

### Tutorials
- **Godot XR Getting Started**: https://docs.godotengine.org/en/stable/tutorials/xr/xr_primer.html
- **Quest Development Guide**: https://developer.oculus.com/documentation/native/android/mobile-intro/

---

**Status**: ✅ VR/XR setup documentation complete  
**Next Action**: Create Godot project and configure OpenXR settings  
**Document Version**: 1.0  
**Last Updated**: November 10, 2025
