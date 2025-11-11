Beabodocl Godot

A Godot VR/XR Client for Babocument

**Backend API**: This project is a client of [babocument](https://github.com/buddha314/babocument), a FastAPI server providing document management, semantic search, and AI research agent capabilities.

## Backend Integration

The babocument server exposes 17 REST API endpoints:
- **Documents API** (`/api/v1/documents`) - Upload, search, and manage research papers
- **Repositories API** (`/api/v1/repositories`) - Manage external data sources
- **Statistics API** (`/api/v1/stats`) - System metrics and analytics
- **Agent Chat API** (`/api/v1/agent/chat`) - Conversational AI research assistant

Full API documentation available at `http://localhost:8000/docs` when running the backend server.

For backend setup instructions, see: https://github.com/buddha314/babocument

## Early Decisions

* **Target Hardware**: Meta Quest 3 (standalone VR) - 90 FPS target
* **Godot Version**: ✅ 4.5.1 Stable (latest, Oct 2025 - OpenXR built into core!)
* **Asset Workflow**: Blender-first (NOT procedural generation) ⭐ CRITICAL
* **Development Tools**: Godot Editor + GDScript (scene-based, not pure code)
* **Blender Pipeline**: Decision pending (Issue #6) - .blend vs .gltf vs .glb

## General Notes

* **Asset Creation**: All 3D assets developed in Blender, NOT procedurally generated
* **Development**: Godot Editor + GDScript (scene-based workflow)
* **Blender Pipeline**: Assets imported via .blend, .gltf, or .glb (decision in Issue #6)
* **VR Setup**: See `VR_SETUP.md` for complete Quest 3 configuration guide
* **Documents**: Keep in `./specs` folder unless essential to root
* **Aesthetic**: Hybrid cyberpunk-solarpunk (tech + nature, optimistic futurism)
* **Visual References**: See `lookbook/` and `specs/INTERFACE_DESIGN.md`

## Agent Handoff

When preparing for a handoff:
* Create prioritized next steps in `HANDOFF.md`
* Update GitHub issues in `specs/GITHUB_ISSUES.md`
* Provide time savings summary (agent vs human hours)
* Maintain good handoff hygiene for continuity
* Push outstanding commits to main
* Keep detailed session notes in `specs/HANDOFF_SESSION_X.md`