# Quick Start Guide - Beabodocl Godot VR

**For New Developers Joining the Project**

---

## ✅ Current Status (November 10, 2025)

**Phase 0 Complete** - VR deployment is fully operational!

- ✅ Godot 4.5.1 project configured
- ✅ OpenXR enabled with Quest 3 support
- ✅ Android export working
- ✅ **VR mode confirmed on Quest 3** - Immersive, 90 FPS, head tracking working
- ⏳ **Next**: Build hexagonal room environment (Phase 1)

---

## Setup (First Time)

### 1. Install Required Software

- **Godot 4.5.1**: https://godotengine.org/download/
- **Android Studio**: https://developer.android.com/studio
- **Git**: https://git-scm.com/

### 2. Clone Repository

```powershell
git clone https://github.com/buddha314/beabodocl-godot.git
cd beabodocl-godot
```

### 3. Open Project in Godot

- Open Godot 4.5.1
- Click "Import"
- Navigate to `beabodocl-godot/client/project.godot`
- Click "Import & Edit"

### 4. Configure Android Export

**In Godot:**
1. `Editor → Editor Settings → Export → Android`
2. Set **Android SDK Path**: `C:\Users\[YourUser]\AppData\Local\Android\Sdk`
3. Set **Java SDK Path**: `C:\Program Files\Android\Android Studio\jbr`

### 5. Enable Quest 3 Developer Mode

- Install Meta Quest app on phone
- Connect Quest 3 to account
- Enable Developer Mode in app settings
- Connect Quest 3 via USB-C
- Accept USB debugging on headset

---

## Deploy to Quest 3

### One-Click Deploy (Recommended)

**In Godot:**
1. Ensure Quest 3 is connected (`adb devices` shows device)
2. Click dropdown next to Play button (top-right)
3. Select device icon → Choose "Quest 3" preset
4. Click "Run on Remote Android Device"
5. Put on headset - app launches automatically

### Manual Deploy

```powershell
# Build APK in Godot: Project → Export → Quest 3 → Export Project

# Install to Quest 3
adb install -r build\client.apk

# Launch app on headset: Library → Unknown Sources → client
```

---

## Critical Settings (Already Configured)

### In `project.godot`:
- ✅ OpenXR enabled
- ✅ XR shaders enabled
- ✅ Foveated rendering (level 3, dynamic)

### In Export Preset:
- ✅ Gradle build enabled
- ✅ **Meta plugin enabled** (CRITICAL!)
- ✅ XR Mode: OpenXR
- ✅ Architecture: arm64-v8a

**⚠️ WARNING**: If VR mode doesn't work, check `Project → Export → Quest 3 → XR Features → Enable Meta Plugin` is **checked**!

---

## File Structure

```
beabodocl-godot/
├── client/                    # Godot 4.5.1 project ← OPEN THIS
│   ├── main.tscn             # Main VR scene
│   ├── vr_startup.gd         # OpenXR init script
│   ├── project.godot         # Project config
│   └── addons/               # OpenXR vendors plugin
├── specs/                     # Design docs
├── lookbook/                  # Visual references
├── VR_SETUP.md               # Detailed setup guide
├── PLAN.md                   # Project roadmap
├── HANDOFF_SESSION_3.md      # Latest session notes
└── QUICK_START.md            # This file
```

---

## Common Commands

```powershell
# Check Quest 3 connection
adb devices

# View logs
adb logcat -s godot

# Clear logs
adb logcat -c

# Uninstall app
adb uninstall com.example.client
```

---

## Next Steps (Phase 1)

**Issue #3: Create Hexagonal Room**
- Design in Blender (6-sided room, 1.6m height)
- Export to Godot (.gltf or .blend)
- Position 3 display panels at 0°, 120°, 240°
- Implement locomotion (grounded only)
- Test on Quest 3

**Estimated Time**: 12-16 hours

---

## Troubleshooting

### App runs in 2D window, not VR

**Solution**: Enable Meta plugin
1. `Project → Export → Quest 3`
2. Check `XR Features → Enable Meta Plugin`
3. Rebuild APK

### "device unauthorized"

**Solution**: Put on Quest 3, accept USB debugging prompt

### Black screen in VR

**Solution**: 
- Check WorldEnvironment has Environment resource
- Verify XR shaders enabled in Project Settings

---

## Resources

- **Full Setup Guide**: VR_SETUP.md
- **Project Plan**: PLAN.md
- **Latest Handoff**: HANDOFF_SESSION_3.md
- **Godot XR Docs**: https://docs.godotengine.org/en/stable/tutorials/xr/
- **OpenXR Vendors**: https://github.com/GodotVR/godot_openxr_vendors

---

**Questions?** Check HANDOFF_SESSION_3.md for detailed configuration notes.

**Status**: ✅ Ready for development - VR working on Quest 3!
