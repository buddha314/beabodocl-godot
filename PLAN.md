# Beabodocl Godot - Project Plan

**Version**: 1.0  
**Date**: November 10, 2025  
**Status**: Planning Phase

## Overview

Beabodocl Godot is a VR/XR client for the [babocument](https://github.com/buddha314/babocument) research assistant platform. It provides an immersive 3D environment for interacting with scientific literature using a hybrid cyberpunk-solarpunk aesthetic.

## Design Philosophy

### Aesthetic Vision
- **Hybrid Cyberpunk-Solarpunk**: Technology serving humanity, sustainable futurism
- **Organic + Digital**: Natural materials (wood, bamboo, living plants) integrated with holographic displays
- **Positive Futurism**: Hope-oriented, not dystopian
- **Grounded Locomotion**: Standing-only, realistic movement (no flying/jumping)

### Core Principles
1. **User Comfort**: VR-optimized text sizes, matte materials, comfortable distances
2. **Spatial Memory**: Physical navigation aids context switching and information recall
3. **Natural Interaction**: Familiar metaphors (glass panels, physical rooms)
4. **Accessibility**: Multiple input methods (VR controllers, desktop, voice)

## Architecture

### Backend (External)
- **Repository**: https://github.com/buddha314/babocument
- **Technology**: FastAPI (Python)
- **Services**: Document management, semantic search, AI agents, vector database
- **API**: 17 REST endpoints + WebSocket for real-time agent chat
- **Local URL**: http://localhost:8000

### Frontend (This Repository)
- **Technology**: Godot Engine (version TBD - must support VR/XR well)
- **Development Approach**: **Godot Editor + GDScript** (not pure code)
- **Asset Creation**: **Blender-first workflow** (NOT procedural generation)
  - All 3D models, rooms, panels created in Blender
  - Materials and textures authored externally
  - Import to Godot via .blend/.gltf/.glb (decision in Issue #6)
  - Procedural generation only when absolutely necessary
- **Scene Building**: Godot Editor for scene composition and layout
- **Scripting**: GDScript for logic, interactions, API integration
- **Platform Targets**: 
  - Meta Quest 3 (standalone VR)
  - Desktop (PCVR via SteamVR)
  - Potential: PSVR2, other OpenXR-compatible headsets
- **HTTP Client**: TBD (Godot HTTPRequest or plugin)

## Environment Design

### Hexagonal Room
- **Geometry**: 6-sided room, standing height (1.6m)
- **Movement**: Grounded locomotion only - walk/strafe, no vertical movement
- **Three Display Panels**:
  1. **Chat Panel** (front-facing) - AI agent conversation interface
  2. **Document Panel** (120° rotation) - Paper viewer/reader
  3. **Visualization Panel** (240° rotation) - Search results, graphs, data viz

### Materials & Textures
- **Tech Elements**: Holographic displays, corrugated metal, dark stone
- **Organic Elements**: Reclaimed wood, bamboo, living moss, bioluminescent accents
- **Hybrid Approach**: Metal frames with wood trim, industrial surfaces with plant growth
- **Lighting**: Warm sunlight, soft shadows, optional bioluminescent details

## Development Phases

### Phase 0: Foundation (Week 1-2) - **PRIORITY**
**Goal**: Establish development environment and core decisions

- [ ] **Issue #1: Godot Version Selection & Setup**
  - Research Godot 4.x VR/XR capabilities
  - Test OpenXR plugin compatibility
  - Set up project structure
  - Configure version control
  - Document setup process
  - **Time**: 6-8 hours

- [ ] **Issue #2: API Client Implementation**
  - Implement HTTP client for babocument API
  - Create request/response models (GDScript classes)
  - Test connectivity to all endpoints
  - Handle errors and timeouts
  - Document API integration patterns
  - **Time**: 8-12 hours

- [ ] **Blender Asset Pipeline Decision**
  - Evaluate .blend vs .gltf/.glb export
  - Test import workflow in Godot
  - Document best practices
  - **Time**: 2-4 hours

### Phase 1: Core Environment (Week 3-4)
**Goal**: Functional VR room with basic navigation

- [ ] **Issue #3: VR Environment Setup**
  - Implement hexagonal room geometry
  - Configure XR camera and controllers
  - Implement grounded locomotion (standing, lateral movement only)
  - Test on target VR hardware
  - Optimize performance (90 FPS target)
  - **Time**: 12-16 hours

- [ ] **Issue #4: Panel System**
  - Create modular panel prefab/scene
  - Implement 2-layer design (background + screen)
  - Position 3 panels in hexagon
  - Add basic lighting
  - Apply placeholder materials
  - **Time**: 6-8 hours

### Phase 2: Chat Interface (Week 5-6)
**Goal**: Working AI chat panel connected to backend agent

- [ ] **Issue #5: Chat UI Implementation**
  - Build chat message display (scrollable)
  - Implement input field (VR keyboard integration)
  - Create message bubbles (user vs agent)
  - Add typing indicators
  - Implement holographic/transparent shader
  - **Time**: 10-14 hours

- [ ] **Issue #6: Agent Integration**
  - Connect to `/api/v1/agent/chat` endpoint
  - Implement WebSocket for real-time updates (optional Phase 2.5)
  - Display agent responses
  - Handle conversation history
  - Add error states and retry logic
  - **Time**: 8-10 hours

### Phase 3: Document Viewer (Week 7-8)
**Goal**: Display and navigate research papers

- [ ] **Issue #7: Document Panel UI**
  - Text rendering for scientific papers
  - Scrolling and pagination
  - Metadata display (title, authors, year)
  - Zoom controls
  - **Time**: 10-12 hours

- [ ] **Issue #8: Document API Integration**
  - Fetch document list from `/api/v1/documents`
  - Load document content
  - Search integration
  - **Time**: 6-8 hours

### Phase 4: Visual Enhancement (Week 9-10)
**Goal**: Implement aesthetic vision with textures and materials

- [ ] **Issue #9: Material System**
  - Generate/source PBR textures (albedo, normal, roughness)
  - Create cyberpunk materials (metal, stone)
  - Create solarpunk materials (wood, bamboo, living walls)
  - Apply to panels and room
  - Optimize for VR performance
  - **Time**: 12-16 hours

- [ ] **Issue #10: Lighting & Atmosphere**
  - Implement warm ambient lighting
  - Add bioluminescent accents (emissive materials)
  - Create procedural sky or skybox
  - Test in VR for comfort
  - **Time**: 6-8 hours

### Phase 5: Advanced Features (Week 11+)
**Goal**: Polish and extended functionality

- [ ] **Issue #11: Search & Visualization Panel**
  - Search interface
  - Display search results
  - Integrate Plotly visualizations (keyword trends, word clouds)
  - **Time**: 14-18 hours

- [ ] **Issue #12: Voice Input** (Optional)
  - Integrate speech recognition
  - Voice commands for navigation
  - Voice input for chat
  - **Time**: 8-12 hours

- [ ] **Issue #13: User Settings**
  - Locomotion preferences
  - UI scale adjustment
  - Color theme options
  - **Time**: 6-8 hours

## Technical Specifications

### API Endpoints (Backend)
```
POST /api/v1/agent/chat              # AI conversation
GET  /api/v1/documents                # List papers
GET  /api/v1/documents/{id}           # Get document metadata
GET  /api/v1/documents/{id}/content   # Get full text
POST /api/v1/documents/search         # Search papers
GET  /api/v1/repositories             # List data sources
GET  /api/v1/stats                    # System statistics
```

### Performance Targets
- **VR Frame Rate**: 90 FPS (Quest 3 target), 72 FPS minimum
- **Desktop**: 60+ FPS
- **Latency**: <100ms for API requests
- **Text Rendering**: 24-26px for body text in VR

### Data Models (GDScript)
```gdscript
class_name DocumentMetadata
var id: String
var title: String
var authors: Array[String]
var year: int
var source: String
var created_at: String

class_name ChatMessage
var role: String  # "user" or "agent"
var content: String
var timestamp: String
var sources: Array  # Optional citations
```

## Asset Requirements

### 3D Models (Blender)
- Hexagonal room architecture
- Panel frames (with organic/tech hybrid design)
- UI element meshes (optional decorative elements)
- Furniture/environmental details (future)

### Textures (ComfyUI/Stable Diffusion + Manual)
- **Cyberpunk**: Corrugated metal, dark stone, industrial surfaces
- **Solarpunk**: Wood grain, bamboo lattice, living moss, mycelium
- **Hybrid**: Metal with moss growth, wood with tech accents
- All textures: PBR workflow (albedo, normal, roughness, metallic, AO)
- Resolution: 1024x1024 to 2048x2048

### Shaders
- Holographic glass effect (transparent panels)
- Emissive materials (bioluminescent accents)
- Matte PBR shaders (reduce VR glare)

## Design References

### Documents
- `specs/INTERFACE_DESIGN.md` - Complete visual specification
- `specs/VISUALIZATION_REQUIREMENTS.md` - Data visualization needs
- `lookbook/` - Visual style references

### Backend Integration
- https://github.com/buddha314/babocument
- API Docs: http://localhost:8000/docs (when server running)
- CLIENT_API_INTEGRATION_PLAN.md (reference architecture for BabylonJS - adapt for Godot)

## Success Criteria

### MVP (Minimum Viable Product)
- [ ] VR-navigable hexagonal room
- [ ] Working chat panel with AI agent responses
- [ ] Grounded locomotion (standing, lateral only)
- [ ] Basic materials applied
- [ ] Deployable to Meta Quest 3
- [ ] 90 FPS performance

### V1.0
- [ ] All three panels functional (chat, document, visualization)
- [ ] Full aesthetic implementation (cyberpunk-solarpunk hybrid)
- [ ] Document viewing and search
- [ ] Smooth VR experience (comfort tested)

### Future
- [ ] Voice input
- [ ] Multi-user collaboration
- [ ] 3D data visualization
- [ ] Gesture controls
- [ ] Customizable environments

## Development Workflow

### Asset-First Development Philosophy

**CRITICAL: This project uses a Blender-first asset creation workflow**

All 3D assets are created in Blender and imported to Godot. Procedural generation is avoided unless absolutely necessary for performance or dynamic content.

**Why Blender-First:**
1. **Artistic Control**: Precise control over aesthetics (cyberpunk-solarpunk hybrid)
2. **Material Quality**: PBR materials authored with full texture control
3. **Iteration Speed**: Faster to model/texture in Blender than code procedurally
4. **Reusability**: Assets can be reused across scenes
5. **Collaboration**: Artists can work in familiar tools
6. **Quality**: Hand-crafted assets match the design vision better

**What Gets Created in Blender:**
- ✅ Hexagonal room geometry (walls, floor, ceiling)
- ✅ Panel frames and backgrounds
- ✅ Decorative elements (organic accents, tech details)
- ✅ Furniture and environmental props
- ✅ UI panel meshes
- ✅ All textures and materials (PBR workflow)

**What Might Be Procedural (Only If Necessary):**
- ⚠️ Particle effects (bioluminescent motes, floating particles)
- ⚠️ Shader effects (holographic display, scanlines)
- ⚠️ Dynamic UI elements (text, scrolling, animations)

**Godot Editor Usage:**
- Scene composition and layout
- Lighting and environment setup
- XR camera and controller configuration
- Node hierarchy organization
- Script attachment and configuration
- Testing and iteration

**GDScript Usage:**
- API client logic
- User input handling
- UI interactions
- State management
- Animation control
- Performance optimization

### Version Control
- **Main branch**: Stable, deployable builds
- **Develop branch**: Active development
- **Feature branches**: `feature/chat-ui`, `feature/vr-navigation`, etc.
- **Issue branches**: `issue-3-vr-environment`

### Testing Strategy
1. **Unit Testing**: GDScript unit tests for API client, data models
2. **Integration Testing**: Test full workflows (chat → backend → display)
3. **VR Testing**: Regular testing on Quest 3 hardware
4. **Performance Profiling**: Monitor FPS, memory, draw calls

### Documentation
- Update README.md with setup instructions
- Document GDScript API patterns
- Create asset pipeline guide
- Maintain handoff notes for agent collaboration

## Open Questions & Decisions Needed

### Critical Decisions (Phase 0)
1. **Godot Version**: 4.2? 4.3? Latest stable?
   - Must verify OpenXR support quality
   - Check VR performance benchmarks
   - Research community VR projects

2. **HTTP Client**: Built-in HTTPRequest vs. plugin?
   - Test WebSocket support for real-time agent chat
   - Evaluate JSON parsing libraries

3. **Blender Export Format**: .blend, .gltf, .glb, or Godot native?
   - Test material preservation
   - Evaluate file sizes and performance

### Nice-to-Have Investigations
- Godot MCP (Model Context Protocol) client support?
- Text-to-speech for agent responses?
- Eye tracking integration (Quest Pro)?
- Hand tracking vs. controller input?

## Next Steps (Immediate)

1. ✅ Update README with backend API link
2. ✅ Create this PLAN.md
3. ⏳ Create GitHub issues for Phase 0 (#1, #2, Blender decision)
4. ⏳ Create handoff document (HANDOFF.md)
5. ⏳ Research Godot 4.x VR capabilities
6. ⏳ Test connection to babocument API from Godot
7. ⏳ Set up initial Godot project structure

## Resources

### Godot VR/XR
- Godot OpenXR Plugin: https://github.com/GodotVR/godot_openxr
- Godot XR Documentation: https://docs.godotengine.org/en/stable/tutorials/xr/
- XR Tools: https://github.com/GodotVR/godot-xr-tools

### Backend
- Babocument Repo: https://github.com/buddha314/babocument
- API Documentation: http://localhost:8000/docs
- Setup Guide: https://github.com/buddha314/babocument/blob/main/SETUP.md

### Asset Creation
- Blender: https://www.blender.org/
- ComfyUI: https://github.com/comfyanonymous/ComfyUI
- Poly Haven (PBR textures): https://polyhaven.com/
- ambientCG (free textures): https://ambientcg.com/

---

**Status**: Ready for Phase 0 implementation  
**Last Updated**: November 10, 2025  
**Next Review**: After Phase 0 completion
