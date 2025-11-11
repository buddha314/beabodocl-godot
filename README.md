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

* Which Godot Version to use that support VR/XR well.
* Which Godot MCP client to use
* Blender hand-off process. Save `.blend` or something else?

## General Notes

* Assets will be developed in Blender and saved in Godot as well.
* Confine documents to the ./specs folder unless strong reason not to
* The general aesthetic is half cyberpunk, half solar punk
* Examples in the lookbook directory also in specs/Visualization_requirements.md

## Agent Handoff

When preparing for a handoff:
* Create a prioritized document of next steps
* Create or update any needed github issues
* Provide summary of time saved (agent hours vs human hours)
* Maintain good handoff hygiene for next session
* Push outstanding commits to main