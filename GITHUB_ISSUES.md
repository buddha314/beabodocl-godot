# GitHub Issues - Ready to Create

This document contains issue templates ready to be created on GitHub for the beabodocl-godot repository.

---

## Issue #1: Godot Version Selection & VR/XR Setup

**Labels**: `P0`, `foundation`, `vr`, `decision`  
**Milestone**: Phase 0 - Foundation  
**Assignee**: TBD

### Summary

Research and select the appropriate Godot Engine version for VR/XR development, then set up the initial project structure with OpenXR support.

### Background

The project requires VR/XR capabilities for Meta Quest 2/3 and desktop PCVR. Godot 4.x has significantly improved VR support compared to 3.x, but we need to determine which specific version (4.2, 4.3, or latest stable) provides the best balance of features, stability, and performance for our needs.

### Tasks

- [ ] Research Godot 4.x VR/XR capabilities
  - Compare 4.2, 4.3, and latest stable versions
  - Review OpenXR plugin compatibility and maturity
  - Check community VR projects and case studies
  - Verify Meta Quest 2/3 support and deployment process
- [ ] Test VR performance benchmarks
  - Create simple test scene with basic geometry
  - Test on Quest 2/3 hardware
  - Measure baseline FPS and latency
  - Verify 90 FPS achievability
- [ ] Set up project structure
  - Initialize Godot project
  - Configure OpenXR plugin
  - Set up version control (.gitignore, .gitattributes)
  - Create folder structure (scenes/, scripts/, assets/, etc.)
  - Configure project settings for VR
- [ ] Document setup process
  - Write setup instructions in README.md
  - Document VR-specific configurations
  - Create troubleshooting guide
- [ ] Test XR camera and controller input
  - Verify 6DOF tracking
  - Test controller input (buttons, triggers, joysticks)
  - Test hand tracking (if available)

### Acceptance Criteria

- [ ] Godot version selected with clear rationale documented
- [ ] Project initialized and runs on Quest 2/3
- [ ] OpenXR plugin configured and working
- [ ] Basic VR scene loads and renders at 90 FPS
- [ ] Controller input detected and responsive
- [ ] Setup documentation complete
- [ ] Git repository properly configured

### Technical Considerations

**Godot Version Candidates:**
- **4.2 LTS**: Long-term support, most stable
- **4.3**: Newer features, improved performance
- **4.4+**: Latest features, may be less stable

**OpenXR Plugin:**
- GitHub: https://github.com/GodotVR/godot_openxr
- Must verify compatibility with chosen Godot version

**VR Performance Targets:**
- Quest 2/3: 90 FPS (minimum 72 FPS)
- Desktop PCVR: 90+ FPS
- Low latency (<20ms motion-to-photon)

### Dependencies

None - this is the foundation for all other work

### Estimated Time

6-8 hours

### References

- PLAN.md - Phase 0
- specs/INTERFACE_DESIGN.md - VR requirements
- Godot XR Docs: https://docs.godotengine.org/en/stable/tutorials/xr/

---

## Issue #2: HTTP API Client Implementation

**Labels**: `P0`, `foundation`, `backend`, `networking`  
**Milestone**: Phase 0 - Foundation  
**Assignee**: TBD

### Summary

Implement an HTTP client in GDScript to communicate with the babocument FastAPI backend, supporting all necessary REST endpoints for document management and agent chat.

### Background

The babocument server exposes 17 REST endpoints for documents, repositories, statistics, and AI agent chat. The Godot client needs a robust HTTP client to consume these endpoints with proper error handling, JSON parsing, and async request management.

**Backend API**: https://github.com/buddha314/babocument  
**API Docs**: http://localhost:8000/docs

### Tasks

- [ ] Create HTTP client singleton/autoload
  - Use Godot's HTTPRequest node
  - Implement request queuing (avoid concurrent request limits)
  - Add timeout handling
  - Add retry logic with exponential backoff
- [ ] Implement data models (GDScript classes)
  - DocumentMetadata
  - DocumentContent
  - ChatMessage
  - SearchQuery
  - RepositoryInfo
  - SystemStats
- [ ] Implement API methods
  - Documents API (list, get, upload, delete, search)
  - Agent API (chat, conversation history)
  - Repositories API (list, status)
  - Stats API (system statistics)
- [ ] Test connectivity
  - Test all endpoints with mock data
  - Verify JSON parsing
  - Test error scenarios (timeout, 404, 500)
  - Test large responses (pagination)
- [ ] Document API integration
  - Create API_CLIENT.md with usage examples
  - Document error codes and handling
  - Add code comments

### API Endpoints to Implement

**Agent Chat:**
```
POST /api/v1/agent/chat
Body: {"message": "What papers do you have?"}
Response: {"message": "...", "conversation_id": "...", "sources": [...]}
```

**Documents:**
```
GET  /api/v1/documents?limit=20&offset=0
GET  /api/v1/documents/{id}
GET  /api/v1/documents/{id}/content
POST /api/v1/documents (file upload)
POST /api/v1/documents/search
```

**Repositories:**
```
GET /api/v1/repositories
GET /api/v1/repositories/{id}/status
```

**Stats:**
```
GET /api/v1/stats
```

### GDScript Example

```gdscript
# Singleton: res://scripts/api_client.gd
extends Node

const BASE_URL = "http://localhost:8000"

signal chat_response_received(response: Dictionary)
signal documents_loaded(documents: Array)
signal error_occurred(error_message: String)

func send_chat_message(message: String) -> void:
    var http = HTTPRequest.new()
    add_child(http)
    http.request_completed.connect(_on_chat_response)
    
    var headers = ["Content-Type: application/json"]
    var body = JSON.stringify({"message": message})
    
    http.request(BASE_URL + "/api/v1/agent/chat", headers, HTTPClient.METHOD_POST, body)

func _on_chat_response(result, response_code, headers, body):
    if response_code == 200:
        var json = JSON.parse_string(body.get_string_from_utf8())
        chat_response_received.emit(json)
    else:
        error_occurred.emit("HTTP " + str(response_code))
```

### Acceptance Criteria

- [ ] HTTP client singleton created
- [ ] All data models implemented
- [ ] All API methods working
- [ ] Error handling tested
- [ ] Timeout and retry logic working
- [ ] Documentation complete
- [ ] Successfully connects to running babocument server
- [ ] Can send chat message and receive response
- [ ] Can fetch document list

### Technical Considerations

**HTTPRequest vs. HTTPClient:**
- HTTPRequest: Higher level, easier async handling
- HTTPClient: Lower level, more control
- **Recommendation**: Start with HTTPRequest

**JSON Parsing:**
- Use built-in JSON.parse_string()
- Validate response structure before accessing fields

**WebSocket (Future):**
- For real-time agent chat updates
- Consider for Phase 2.5
- May need WebSocket plugin or built-in support

### Dependencies

- Babocument server must be running (http://localhost:8000)
- Issue #1 (Godot setup) must be complete

### Estimated Time

8-12 hours

### References

- https://github.com/buddha314/babocument - Backend repo
- CLIENT_API_INTEGRATION_PLAN.md - Architecture reference (adapt from BabylonJS)
- Godot HTTPRequest docs: https://docs.godotengine.org/en/stable/classes/class_httprequest.html

---

## Issue #3: VR Environment Setup - Hexagonal Room

**Labels**: `P1`, `vr`, `environment`, `3d`  
**Milestone**: Phase 1 - Core Environment  
**Assignee**: TBD

### Summary

Create the hexagonal VR room environment with grounded locomotion, XR camera setup, and positioned display panels.

### Background

Per specs/INTERFACE_DESIGN.md, the user stands in a large hexagonal room with three display panels positioned on alternating walls. Movement is grounded (standing, lateral only - no flying/jumping) at 1.6m height. This is the primary workspace for all interactions.

### Tasks

- [ ] Create hexagonal room geometry
  - Model in Blender OR procedurally in Godot
  - 6 walls, hexagonal floor and ceiling (optional)
  - Room diameter: ~10-12 meters (comfortable walking space)
  - Wall height: 4 meters
  - Export/import to Godot
- [ ] Configure XR camera
  - Set up XROrigin3D and XRCamera3D nodes
  - Lock height at 1.6m (standing eye level)
  - Configure near/far clipping planes
  - Test 6DOF tracking
- [ ] Implement grounded locomotion
  - **No vertical movement**: No jumping, hovering, or flying
  - **Lateral movement only**: Forward/back, strafe left/right
  - Continuous movement via joystick
  - Optional: Snap turning (comfort option)
  - Optional: Teleport locomotion (comfort option)
  - Collision detection with walls
- [ ] Create panel positioning system
  - Place 3 panel positions in hexagon
  - Panel 1 (Chat): 0° - front-facing
  - Panel 2 (Document): 120° rotation
  - Panel 3 (Visualization): 240° rotation
  - Distance from center: ~4-5 meters
  - Height: Eye level (1.6m)
  - All panels face inward toward center
- [ ] Add basic lighting
  - Ambient light (warm tone)
  - Directional light (simulated sunlight)
  - Test in VR for visibility and comfort
- [ ] Apply placeholder materials
  - Simple PBR materials (gray walls, neutral colors)
  - Matte finish (roughness = 1.0)
  - No bright colors (VR comfort)
- [ ] Test on VR hardware
  - Deploy to Quest 2/3
  - Test locomotion comfort
  - Verify 90 FPS performance
  - Check panel positioning and readability
  - User comfort test (motion sickness check)

### Scene Hierarchy

```
VREnvironment (Node3D)
├── XROrigin3D
│   ├── XRCamera3D (height locked at 1.6)
│   ├── LeftController (XRController3D)
│   └── RightController (XRController3D)
├── HexagonalRoom (Node3D)
│   ├── Floor (MeshInstance3D)
│   ├── Ceiling (MeshInstance3D)
│   ├── Wall1 (MeshInstance3D)
│   ├── Wall2 (MeshInstance3D)
│   ├── ... (6 walls total)
│   └── StaticBody3D (collision)
├── Panels (Node3D)
│   ├── ChatPanel (at 0°)
│   ├── DocumentPanel (at 120°)
│   └── VizPanel (at 240°)
└── Lighting (Node3D)
    ├── DirectionalLight3D (sunlight)
    └── Environment (ambient, sky)
```

### Locomotion System (GDScript)

```gdscript
extends XROrigin3D

@export var move_speed: float = 2.0  # meters per second
@export var snap_turn_angle: float = 45.0  # degrees
@export var height_lock: float = 1.6  # meters (standing height)

func _physics_process(delta):
    # Lock vertical position
    global_position.y = height_lock
    
    # Get joystick input from controller
    var move_vector = Vector2.ZERO
    # ... read from XRController3D
    
    # Apply movement (no vertical component)
    var direction = Vector3(move_vector.x, 0, -move_vector.y)
    direction = direction.rotated(Vector3.UP, $XRCamera3D.global_rotation.y)
    global_position += direction * move_speed * delta
```

### Acceptance Criteria

- [ ] Hexagonal room visible and properly scaled
- [ ] XR camera tracking works (6DOF)
- [ ] Height locked at 1.6m (no vertical drift)
- [ ] Grounded locomotion working (lateral only)
- [ ] Three panel positions marked and accessible
- [ ] User can walk around room and view all panels
- [ ] 90 FPS on Quest 2/3
- [ ] No motion sickness issues
- [ ] Collision prevents walking through walls

### Performance Targets

- **Frame Rate**: 90 FPS minimum (Quest 2/3)
- **Draw Calls**: <50 for basic room
- **Vertices**: <10,000 for room geometry
- **Texture Memory**: <50 MB for placeholder materials

### Dependencies

- Issue #1 (Godot VR setup) must be complete

### Estimated Time

12-16 hours

### References

- specs/INTERFACE_DESIGN.md - Hexagonal room specification
- PLAN.md - Environment design
- Godot XR Tools: https://github.com/GodotVR/godot-xr-tools (locomotion examples)

---

## Issue #4: Chat Panel UI Implementation

**Labels**: `P1`, `ui`, `vr`, `chat`  
**Milestone**: Phase 2 - Chat Interface  
**Assignee**: TBD

### Summary

Build the holographic chat interface panel for displaying AI agent conversations with transparent glass aesthetic and VR-optimized text rendering.

### Background

The chat panel is the primary interface for interacting with the babocument AI research assistant. It features a modern, transparent design inspired by holographic interfaces, with floating text on a glass-like surface backed by a textured panel.

**Design**: specs/INTERFACE_DESIGN.md - Chat Panel System

### Tasks

- [ ] Create panel background
  - 2-layer design: background panel + transparent screen
  - Background: ~500x350 units (or meters)
  - Screen: ~400x300 units, offset ~0.5m forward
  - Billboard mode (always face user) OR fixed orientation?
- [ ] Implement transparent holographic shader
  - Glass-like material (alpha ~0.2)
  - Subtle blue-purple tint (#6A6AAF)
  - Optional: Scanline effect
  - Optional: Edge glow
  - Matte finish to reduce glare
- [ ] Build chat message display
  - Scrollable message container (Control node)
  - Message bubble components (Label or RichTextLabel)
  - User messages vs agent messages (different styling)
  - Timestamp display
  - Auto-scroll to newest message
- [ ] Create input field
  - VR keyboard integration (on-screen keyboard)
  - OR: Voice input (future enhancement)
  - Send button
  - Character limit indicator
  - Placeholder text
- [ ] Add typing indicator
  - Animated "..." when agent is thinking
  - Display during API request
- [ ] Optimize text rendering for VR
  - Font size: 24-26px for body text
  - High contrast (white text on dark/transparent background)
  - Anti-aliasing enabled
  - Distance-appropriate scaling
  - Test readability at 4-5 meter distance

### UI Hierarchy

```
ChatPanel (Node3D)
├── BackgroundPanel (MeshInstance3D)
│   └── Material: PBRMaterial (solid, warm tone)
├── ScreenPanel (MeshInstance3D)
│   ├── Material: ShaderMaterial (transparent holographic)
│   └── SubViewport
│       └── ChatUI (Control)
│           ├── MessageContainer (ScrollContainer)
│           │   └── MessageList (VBoxContainer)
│           │       ├── UserMessage1 (PanelContainer + Label)
│           │       ├── AgentMessage1 (PanelContainer + Label)
│           │       └── TypingIndicator (AnimatedLabel)
│           └── InputArea (HBoxContainer)
│               ├── InputField (LineEdit or TextEdit)
│               └── SendButton (Button)
```

### Holographic Shader (Example)

```gdscript
shader_type spatial;

uniform vec4 glass_color : source_color = vec4(0.42, 0.42, 0.69, 0.2);
uniform float edge_glow_strength : hint_range(0.0, 2.0) = 0.5;

void fragment() {
    ALBEDO = glass_color.rgb;
    ALPHA = glass_color.a;
    ROUGHNESS = 1.0;  // Matte
    METALLIC = 0.0;
    
    // Optional: Edge glow effect
    float fresnel = pow(1.0 - dot(VIEW, NORMAL), 3.0);
    EMISSION = vec3(0.42, 0.42, 0.69) * fresnel * edge_glow_strength;
}
```

### VR Text Rendering Best Practices

1. **Font Size**: Minimum 24px at ~4m distance
2. **Contrast**: White text (#FFFFFF) on dark transparent background
3. **Font**: Sans-serif, medium-bold weight
4. **Line Spacing**: 1.4-1.6x
5. **Anti-aliasing**: MSDF (Multi-channel Signed Distance Field) fonts
6. **Avoid**: Small text, thin fonts, low contrast

### Message Bubble Styling

**User Message:**
- Align: Right
- Background: Light blue tint (#6A9BFF, 30% opacity)
- Text color: White (#FFFFFF)
- Padding: 10-15px

**Agent Message:**
- Align: Left
- Background: Light purple tint (#9B6AFF, 30% opacity)
- Text color: White (#FFFFFF)
- Padding: 10-15px

### Acceptance Criteria

- [ ] Chat panel visible in VR environment
- [ ] Transparent holographic shader applied and working
- [ ] Text readable at 4-5 meter distance
- [ ] Message display scrollable
- [ ] User and agent messages styled differently
- [ ] Input field functional (keyboard input works)
- [ ] Typing indicator displays during agent responses
- [ ] UI performs at 90 FPS
- [ ] No visual glitches or z-fighting

### Performance Considerations

- **SubViewport Resolution**: 1024x768 or 2048x1536 (test performance)
- **Update Frequency**: Only update when new messages arrive
- **Texture Filtering**: Linear with mipmaps

### Dependencies

- Issue #3 (VR Environment) must be complete for panel positioning

### Estimated Time

10-14 hours

### References

- specs/INTERFACE_DESIGN.md - Chat Panel System
- lookbook/ - Visual style references
- Godot SubViewport docs: https://docs.godotengine.org/en/stable/classes/class_subviewport.html

---

## Issue #5: Agent Chat Integration

**Labels**: `P1`, `backend`, `chat`, `api`  
**Milestone**: Phase 2 - Chat Interface  
**Assignee**: TBD

### Summary

Connect the chat UI to the babocument agent API endpoint, enabling real-time conversation with the AI research assistant.

### Background

With the chat UI built (Issue #4) and HTTP client ready (Issue #2), this task integrates them to enable actual conversations with the babocument AI agent via the `/api/v1/agent/chat` endpoint.

### Tasks

- [ ] Connect input field to API client
  - Capture user input on send button press
  - Call APIClient.send_chat_message()
  - Display user message immediately in UI
  - Show typing indicator while waiting
- [ ] Handle agent responses
  - Listen for chat_response_received signal
  - Parse response JSON
  - Extract message content and metadata
  - Display agent message in UI
  - Hide typing indicator
- [ ] Implement conversation history
  - Store messages locally (Array of ChatMessage)
  - Optional: Persist to file between sessions
  - Load previous conversation on startup
  - Support conversation_id from API
- [ ] Add error handling
  - Network errors (timeout, connection refused)
  - API errors (500, rate limiting)
  - Display error messages to user
  - Retry logic with exponential backoff
- [ ] Implement source citations
  - Parse sources array from agent response
  - Display document references
  - Make citations clickable (future: load document)
- [ ] Add loading states
  - Typing indicator animation
  - Disable input during request
  - Show "Thinking..." or similar message
- [ ] Test end-to-end flow
  - Send message → receive response
  - Multiple messages in conversation
  - Error scenarios
  - Long responses (test scrolling)

### API Integration

**Endpoint**: `POST /api/v1/agent/chat`

**Request:**
```json
{
  "message": "What papers do you have about bioprinting?",
  "conversation_id": "uuid-optional"
}
```

**Response:**
```json
{
  "message": "I found several papers on bioprinting...",
  "conversation_id": "550e8400-e29b-41d4-a716-446655440000",
  "sources": [
    {
      "id": "doc123",
      "title": "3D Bioprinting of Human Tissues",
      "relevance_score": 0.95
    }
  ],
  "metadata": {
    "model": "llama3",
    "response_time_ms": 1234
  }
}
```

### GDScript Example

```gdscript
# In chat_panel.gd
extends Node3D

@onready var api_client = $"/root/APIClient"
@onready var input_field = $ScreenPanel/SubViewport/ChatUI/InputArea/InputField
@onready var message_list = $ScreenPanel/SubViewport/ChatUI/MessageContainer/MessageList
@onready var typing_indicator = $ScreenPanel/SubViewport/ChatUI/MessageContainer/TypingIndicator

var conversation_id: String = ""

func _ready():
    api_client.chat_response_received.connect(_on_chat_response)
    api_client.error_occurred.connect(_on_error)

func _on_send_button_pressed():
    var message = input_field.text
    if message.is_empty():
        return
    
    # Display user message
    add_message("user", message)
    input_field.text = ""
    
    # Show typing indicator
    typing_indicator.visible = true
    
    # Send to API
    api_client.send_chat_message(message, conversation_id)

func _on_chat_response(response: Dictionary):
    typing_indicator.visible = false
    
    # Update conversation ID
    if response.has("conversation_id"):
        conversation_id = response["conversation_id"]
    
    # Display agent message
    add_message("agent", response["message"])
    
    # Display sources (optional)
    if response.has("sources"):
        add_sources(response["sources"])

func add_message(role: String, content: String):
    var message_bubble = preload("res://scenes/ui/message_bubble.tscn").instantiate()
    message_bubble.set_message(role, content)
    message_list.add_child(message_bubble)
    
    # Scroll to bottom
    await get_tree().process_frame
    $MessageContainer.scroll_vertical = message_list.size.y

func _on_error(error: String):
    typing_indicator.visible = false
    add_message("system", "Error: " + error)
```

### Acceptance Criteria

- [ ] User can type message and send
- [ ] Message appears in chat UI immediately
- [ ] Typing indicator shows while waiting
- [ ] Agent response displays correctly
- [ ] Conversation history maintained
- [ ] Sources/citations displayed (if present)
- [ ] Error messages displayed gracefully
- [ ] Network errors handled with retry
- [ ] Multiple messages in conversation work
- [ ] UI remains responsive during requests

### Edge Cases to Handle

1. **Empty messages**: Disable send button if input is empty
2. **Very long messages**: Wrap text, scroll properly
3. **Rapid messages**: Queue requests, don't send simultaneously
4. **Connection lost**: Show clear error, offer retry
5. **Slow responses**: Show progress or timeout after 30s
6. **Malformed JSON**: Catch parsing errors, log and display error

### Testing Scenarios

1. Send "What papers do you have?" → expect list of papers
2. Send follow-up question → verify conversation_id maintained
3. Disconnect network → verify error handling
4. Send very long message → verify UI handles scrolling
5. Restart app → verify conversation history persists (if implemented)

### Dependencies

- Issue #2 (HTTP API Client) must be complete
- Issue #4 (Chat UI) must be complete
- Babocument server must be running

### Estimated Time

8-10 hours

### References

- https://github.com/buddha314/babocument - Backend docs
- API endpoint: http://localhost:8000/docs#/default/chat_with_agent_api_v1_agent_chat_post

---

## Issue #6: Blender Asset Pipeline Decision

**Labels**: `P0`, `foundation`, `assets`, `decision`  
**Milestone**: Phase 0 - Foundation  
**Assignee**: TBD

### Summary

Evaluate and decide on the optimal workflow for creating and importing 3D assets from Blender to Godot, considering file formats, material preservation, and performance.

### Background

The project aesthetic requires custom 3D assets (hexagonal room, panel frames, organic/tech hybrid elements). We need to establish a reliable pipeline for creating these in Blender and importing them to Godot with materials intact.

### Tasks

- [ ] Research export format options
  - **.blend** - Direct import (Godot 4.x supports this)
  - **.gltf** - Industry standard, good material support
  - **.glb** - Binary glTF, smaller file size
  - **.dae** (Collada) - Older format, less recommended
  - **Godot native formats** - .escn, .tscn (via Better Collada Exporter)
- [ ] Test material preservation
  - Create test asset in Blender with PBR materials
  - Export in each format
  - Import to Godot and verify materials
  - Check albedo, normal, roughness, metallic maps
  - Test transparency and emissive materials
- [ ] Test workflow efficiency
  - Time to export/import
  - Ease of re-importing after changes
  - Godot's auto-reimport behavior
  - Version control considerations (binary vs text formats)
- [ ] Evaluate file sizes and performance
  - Compare file sizes for same asset
  - Test load times in Godot
  - Measure draw calls and vertices
  - Test on Quest 2/3 hardware
- [ ] Document recommended workflow
  - Step-by-step export process from Blender
  - Import settings in Godot
  - Material setup best practices
  - Troubleshooting common issues
- [ ] Create template assets
  - Blender starter file with proper settings
  - Example PBR material setup
  - Export preset configurations

### Export Format Comparison

| Format | Pros | Cons |
|--------|------|------|
| **.blend** | Direct import, no export step | Requires Blender installed, larger files |
| **.gltf/.glb** | Industry standard, excellent material support, widely compatible | Requires export step, text format is verbose |
| **.dae** | Widely supported | Poor material preservation, older format |
| **.escn** | Godot native, version control friendly | Requires Better Collada plugin, extra steps |

### Test Asset Requirements

Create a simple test asset with:
- Basic geometry (cube or panel)
- PBR material with:
  - Albedo texture (color map)
  - Normal map (surface detail)
  - Roughness map
  - Metallic map
  - Optional: Emissive map
- Transparent material (for holographic panels)
- Multiple materials on one object

### Recommended Setup (Blender)

1. Use Blender 4.x (or latest 3.x LTS)
2. Set up materials using Principled BSDF
3. Use proper naming conventions (lowercase, underscores)
4. Apply scale/rotation before export (Ctrl+A)
5. Check polygon count (keep under 10k tris for VR)
6. UV unwrap all meshes
7. Organize collections (Room, Panels, Props, etc.)

### Acceptance Criteria

- [ ] Export format selected with documented rationale
- [ ] Test asset successfully imported to Godot
- [ ] Materials preserved correctly
- [ ] Workflow documented in BLENDER_PIPELINE.md
- [ ] Template .blend file created
- [ ] Performance verified on Quest 2/3

### Decision Matrix

Document the decision with:
- **Selected Format**: [.gltf / .glb / .blend / other]
- **Rationale**: Why this format?
- **Workflow**: Step-by-step process
- **Limitations**: Known issues or workarounds
- **Examples**: Screenshots of successful imports

### Dependencies

- Issue #1 (Godot setup) should be complete
- Blender installed (4.x recommended)

### Estimated Time

2-4 hours

### References

- Godot Import Docs: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html
- glTF Spec: https://www.khronos.org/gltf/
- Better Collada Exporter: https://github.com/godotengine/godot-blender-exporter

---

## Summary of Issues

**Phase 0 - Foundation:**
- Issue #1: Godot Version Selection & VR/XR Setup (6-8 hours)
- Issue #2: HTTP API Client Implementation (8-12 hours)
- Issue #6: Blender Asset Pipeline Decision (2-4 hours)

**Phase 1 - Core Environment:**
- Issue #3: VR Environment Setup - Hexagonal Room (12-16 hours)

**Phase 2 - Chat Interface:**
- Issue #4: Chat Panel UI Implementation (10-14 hours)
- Issue #5: Agent Chat Integration (8-10 hours)

**Total Estimated Time (Phase 0-2)**: 46-64 hours

---

**Ready to create on GitHub**: Copy each issue section above and paste into GitHub's "New Issue" form.
