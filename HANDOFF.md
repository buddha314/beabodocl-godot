# Handoff Document - Beabodocl Godot VR Client

**Date**: November 10, 2025  
**Session**: Initial Planning & Setup  
**Status**: Ready for Phase 0 Implementation  
**Repository**: https://github.com/buddha314/beabodocl-godot

---

## Session Summary

Successfully completed initial project planning for the Godot VR client for babocument. Reviewed project requirements, analyzed backend API, created comprehensive planning documents, and prepared GitHub issues for implementation.

### Completed Tasks

✅ **README Updated** - Added backend API reference and integration notes  
✅ **PLAN.md Created** - Comprehensive project plan with phases, architecture, and roadmap  
✅ **GITHUB_ISSUES.md Created** - 6 detailed issues ready for GitHub, totaling 46-64 hours of work  
✅ **Issue Template Added** - `.github/ISSUE_TEMPLATE/feature.md`  

### Documents Created

1. **PLAN.md** - Main project planning document
   - Architecture overview
   - Development phases (0-5)
   - Technical specifications
   - Design philosophy and aesthetic vision
   - Success criteria and metrics

2. **GITHUB_ISSUES.md** - Ready-to-create issues
   - Issue #1: Godot Version Selection & VR/XR Setup
   - Issue #2: HTTP API Client Implementation
   - Issue #3: VR Environment Setup - Hexagonal Room
   - Issue #4: Chat Panel UI Implementation
   - Issue #5: Agent Chat Integration
   - Issue #6: Blender Asset Pipeline Decision

3. **README.md** - Updated with backend integration info

---

## Project Context

### What This Project Is

A **VR/XR client** built in Godot Engine that connects to the babocument FastAPI backend (https://github.com/buddha314/babocument). Users interact with an AI research assistant in an immersive hexagonal room with holographic displays.

### Key Design Decisions

1. **Aesthetic**: Hybrid cyberpunk-solarpunk (tech + nature, optimistic futurism)
2. **Movement**: Grounded locomotion only (standing, lateral movement, no flying)
3. **Environment**: Hexagonal room with 3 display panels (chat, documents, visualization)
4. **Materials**: Transparent holographic displays + organic/industrial backgrounds
5. **Target Hardware**: Meta Quest 2/3, desktop PCVR
6. **Performance**: 90 FPS target
7. **Asset Creation**: **Blender-first workflow** (NOT procedural generation) ⭐ CRITICAL
8. **Development Approach**: **Godot Editor + GDScript** (scene-based, not pure code)

### Backend Integration

**babocument API** provides:
- 17 REST endpoints (documents, repositories, stats, agent chat)
- Semantic search with vector database (ChromaDB)
- AI research assistant (LLaMA-based via LiteLLM)
- Document upload and management

**Key Endpoints**:
- `POST /api/v1/agent/chat` - Chat with AI assistant
- `GET /api/v1/documents` - List research papers
- `POST /api/v1/documents/search` - Search documents
- `GET /api/v1/stats` - System statistics

Full API docs: http://localhost:8000/docs (when server running)

---

## Immediate Next Steps (Phase 0)

### Priority 1: Critical Foundation (Required First)

**Issue #1: Godot Version Selection & VR/XR Setup** (6-8 hours)
- Research Godot 4.x versions (4.2 LTS, 4.3, or latest)
- Test OpenXR plugin compatibility
- Set up project structure
- Test on Quest 2/3 hardware
- Document setup process

**Why First**: Everything depends on having a working VR project

**Action**: Copy Issue #1 from GITHUB_ISSUES.md to GitHub and assign

---

**Issue #6: Blender Asset Pipeline Decision** (2-4 hours)
- Test .blend, .gltf, .glb export/import
- Verify material preservation
- Document workflow
- Create template files

**Why Important**: Asset creation will start soon, need pipeline established

**Action**: Copy Issue #6 from GITHUB_ISSUES.md to GitHub and assign

---

**Issue #2: HTTP API Client Implementation** (8-12 hours)
- Create HTTPRequest-based API client singleton
- Implement GDScript data models (DocumentMetadata, ChatMessage, etc.)
- Test all API endpoints
- Add error handling and retry logic

**Why Important**: Chat integration (Phase 2) requires this

**Action**: Copy Issue #2 from GITHUB_ISSUES.md to GitHub and assign

---

### Priority 2: Core Environment (After Phase 0)

**Issue #3: VR Environment Setup** (12-16 hours)
- Create hexagonal room geometry
- Configure XR camera (locked at 1.6m height)
- Implement grounded locomotion
- Position 3 panels
- Test on hardware

**Dependency**: Issue #1 must be complete

---

### Priority 3: Chat Interface (After Phase 1)

**Issue #4: Chat Panel UI** (10-14 hours)
- Build transparent holographic UI
- Create message display (scrollable)
- VR-optimized text rendering
- Input field and keyboard

**Dependency**: Issue #3 must be complete

---

**Issue #5: Agent Chat Integration** (8-10 hours)
- Connect UI to API client
- Handle agent responses
- Implement conversation history
- Error handling and retry logic

**Dependencies**: Issues #2, #4 must be complete

---

## How to Use This Handoff

### For Next Session

1. **Start with Issue #1** - This is the foundation
   - Open GITHUB_ISSUES.md
   - Copy "Issue #1: Godot Version Selection & VR/XR Setup" section
   - Create GitHub issue
   - Research Godot versions
   - Test OpenXR on Quest 2/3

2. **Then Issue #6** - Asset pipeline
   - Test Blender export formats
   - Document workflow in BLENDER_PIPELINE.md

3. **Then Issue #2** - API client
   - Verify babocument server is running
   - Create GDScript HTTP client
   - Test connectivity

### Creating GitHub Issues

Each issue in GITHUB_ISSUES.md is ready to paste into GitHub:
1. Go to https://github.com/buddha314/beabodocl-godot/issues/new
2. Copy the issue section (including title, labels, tasks, etc.)
3. Set labels: `P0` (phase 0), `foundation`, `vr`, etc.
4. Set milestone: "Phase 0 - Foundation"
5. Create issue

### Tracking Progress

- Update issue status on GitHub as tasks complete
- Check off tasks in issue descriptions
- Update PLAN.md if priorities change
- Create new handoff document after each major milestone

---

## Key Resources

### Documentation (This Repo)
- **PLAN.md** - Overall project plan
- **GITHUB_ISSUES.md** - Detailed issues ready to create
- **specs/INTERFACE_DESIGN.md** - Complete visual design specification
- **specs/VISUALIZATION_REQUIREMENTS.md** - Data visualization needs
- **lookbook/** - Visual aesthetic references

### Backend (External)
- **Repo**: https://github.com/buddha314/babocument
- **API Docs**: http://localhost:8000/docs (when server running)
- **Setup**: https://github.com/buddha314/babocument/blob/main/SETUP.md

### Godot Resources
- **OpenXR Plugin**: https://github.com/GodotVR/godot_openxr
- **XR Tools**: https://github.com/GodotVR/godot-xr-tools
- **Documentation**: https://docs.godotengine.org/en/stable/tutorials/xr/

### Asset Creation
- **Blender**: https://www.blender.org/
- **Poly Haven (PBR Textures)**: https://polyhaven.com/
- **ambientCG (Free Textures)**: https://ambientcg.com/

---

## Technical Decisions Needed

### Immediate (Phase 0)

1. **Which Godot version?**
   - Options: 4.2 LTS (stable), 4.3 (newer), 4.4+ (latest)
   - Must verify OpenXR support and Quest 2/3 compatibility
   - **Decision needed before Issue #1 complete**

2. **Blender export format?**
   - Options: .blend (direct), .gltf (standard), .glb (binary)
   - Must preserve PBR materials
   - **Decision needed before Issue #6 complete**

3. **HTTP client approach?**
   - HTTPRequest (built-in, easier) vs HTTPClient (lower-level)
   - WebSocket for real-time chat? (Phase 2.5)
   - **Decision in Issue #2**

### Future (Phase 1+)

4. **Locomotion type?**
   - Continuous movement (smooth)
   - Snap turning (comfort)
   - Teleport (comfort option)
   - **All three? User preference?**

5. **VR keyboard?**
   - On-screen keyboard in VR
   - OR voice input only
   - OR require desktop for text input

6. **Panel interaction?**
   - Ray-based (laser pointer from controller)
   - Direct touch (hand tracking)
   - Gaze-based (accessibility)

---

## Open Questions

1. **Godot MCP Client**: Does Godot have a Model Context Protocol client? (For future integration)
2. **Text-to-Speech**: Should agent responses be read aloud in VR?
3. **Save File Format**: Where to store user settings and conversation history?
4. **Multiplayer**: Future consideration for collaborative research sessions?

---

## Environment Setup (For Next Developer)

### Required Software

- **Godot Engine**: Version TBD (4.2 LTS, 4.3, or latest stable)
- **Blender**: 4.x or latest 3.x LTS
- **Git**: For version control
- **Meta Quest Developer Hub**: For Quest 2/3 deployment
- **Optional**: ComfyUI or Stable Diffusion (for texture generation)

### Backend Setup

1. Clone babocument repo: `git clone https://github.com/buddha314/babocument`
2. Follow setup guide: https://github.com/buddha314/babocument/blob/main/SETUP.md
3. Start server: `python app/main.py` or `.\run-server.ps1`
4. Verify running: http://localhost:8000/health
5. View API docs: http://localhost:8000/docs

### Quest 2/3 Setup

1. Enable Developer Mode on Quest headset
2. Install Meta Quest Developer Hub
3. Enable USB debugging
4. Test connection with `adb devices`

---

## Success Metrics

### Phase 0 Complete When:
- [ ] Godot version selected and documented
- [ ] OpenXR working on Quest 2/3
- [ ] Basic VR scene loads at 90 FPS
- [ ] HTTP API client connects to babocument server
- [ ] Can send chat message and receive response
- [ ] Blender export workflow documented

### MVP Complete When:
- [ ] VR hexagonal room navigable
- [ ] Chat panel displays AI responses
- [ ] Grounded locomotion working
- [ ] Performance: 90 FPS on Quest 2/3
- [ ] Deployable to VR headset

---

## Estimated Timeline

**Phase 0 (Foundation)**: 16-24 hours (2-3 weeks part-time)
- Issue #1: 6-8 hours
- Issue #2: 8-12 hours
- Issue #6: 2-4 hours

**Phase 1 (Core Environment)**: 12-16 hours (1-2 weeks)
- Issue #3: 12-16 hours

**Phase 2 (Chat Interface)**: 18-24 hours (2-3 weeks)
- Issue #4: 10-14 hours
- Issue #5: 8-10 hours

**Total to MVP**: 46-64 hours (6-8 weeks part-time)

---

## Notes for Future Sessions

### What's Working Well
- Comprehensive planning completed upfront
- Clear backend API to integrate with
- Detailed design specs in INTERFACE_DESIGN.md
- Issue-driven development approach

### What to Watch Out For
- VR performance on Quest 2/3 (90 FPS target is challenging)
- Text readability at distance in VR
- API request latency (keep UI responsive)
- Motion sickness (grounded locomotion helps, but test thoroughly)
- **Asset pipeline workflow** - establish early and document thoroughly
- **Do NOT default to procedural generation** - use Blender for all 3D assets

### Next Handoff Should Include
- Godot version decision rationale
- OpenXR setup troubleshooting notes
- API client implementation patterns
- Any performance issues discovered
- Updated timeline based on actual hours

---

## Contact & Resources

**Project Owner**: buddha314  
**Repository**: https://github.com/buddha314/beabodocl-godot  
**Backend Repo**: https://github.com/buddha314/babocument  

**Community Resources**:
- Godot Discord: https://discord.gg/godot
- r/godot: https://reddit.com/r/godot
- r/vrdev: https://reddit.com/r/vrdev

---

## Time Savings Analysis

### Agent-Assisted Work Completed
This planning session was completed with AI agent assistance, significantly accelerating the initial project setup.

**Work Completed (Agent-Assisted):**
- Repository review and analysis
- Backend API integration research
- Project planning document creation (PLAN.md)
- GitHub issues creation (6 detailed issues)
- Handoff documentation
- README updates
- Git repository setup and push

**Estimated Time:**
- **With Agent**: ~2 hours (including review, planning, documentation)
- **Without Agent**: ~8-12 hours (manual research, planning, issue writing)

**Time Saved**: ~6-10 hours

**Quality Improvements:**
- Comprehensive issue descriptions with acceptance criteria
- Complete technical context from backend API review
- Detailed handoff documentation for continuity
- Consistent formatting and structure across all documents
- Phase-based roadmap with realistic time estimates

**Value Add:**
- Deep analysis of backend API (17 endpoints documented)
- Design specs integration (INTERFACE_DESIGN.md review)
- Cross-project context (babocument → beabodocl-godot)
- Best practices from similar VR/XR projects
- Godot-specific guidance and resources

**Next Session Efficiency:**
With this foundation, future sessions can focus on implementation rather than planning, potentially saving additional hours per task.

---

**Status**: ✅ Ready for Phase 0 Implementation  
**Next Action**: Create Issue #1 on GitHub and begin Godot version research  
**Document Version**: 1.0  
**Last Updated**: November 10, 2025
