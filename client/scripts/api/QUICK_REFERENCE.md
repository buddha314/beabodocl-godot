# API Client Quick Reference

## Quick Start

```gdscript
# In any script, use the global API singleton

# 1. Connect to signals
func _ready():
    API.chat_response_received.connect(_on_chat)
    API.error_occurred.connect(_on_error)

# 2. Make API calls
API.send_chat_message("What papers do you have?")

# 3. Handle responses
func _on_chat(response: Dictionary):
    print("Agent: ", response["message"])
```

## Common API Calls

```gdscript
# Chat with AI agent
API.send_chat_message("Tell me about bioprinting")

# List documents (20 per page)
API.list_documents(20, 0)

# Search documents
API.search_documents("bioprinting", 10)

# Get specific document
API.get_document("doc_id_123")

# Get document content
API.get_document_content("doc_id_123")

# List repositories
API.list_repositories()

# Get stats
API.get_stats()

# Test connectivity
API.ping()
```

## All Signals

```gdscript
API.chat_response_received.connect(func(response: Dictionary): pass)
API.documents_loaded.connect(func(documents: Array): pass)
API.document_loaded.connect(func(document: Dictionary): pass)
API.document_content_loaded.connect(func(content: String): pass)
API.search_results_received.connect(func(results: Array): pass)
API.repositories_loaded.connect(func(repositories: Array): pass)
API.stats_loaded.connect(func(stats: Dictionary): pass)
API.error_occurred.connect(func(error_message: String, error_code: int): pass)
```

## Configuration

```gdscript
API.base_url = "http://localhost:8000"  # Server URL
API.request_timeout = 30.0  # Seconds
API.max_retries = 3  # Retry attempts
API.debug_logging = true  # Enable logs
```

## Testing

```bash
# 1. Start babocument server
cd C:\Users\b\src\babocument
python -m uvicorn app.main:app --reload

# 2. In Godot, open and run:
# res://api_test.tscn
```

## File Locations

- **API Client**: `client/scripts/api/api_client.gd`
- **Data Models**: `client/scripts/api/models.gd`
- **Documentation**: `client/scripts/api/README.md`
- **Test Scene**: `client/api_test.tscn`
- **Test Script**: `client/scripts/api/api_test.gd`

## Data Models

```gdscript
# Available classes in models.gd:
DocumentMetadata
ChatMessage
SearchQuery
RepositoryInfo
SystemStats
DocumentContent
SearchResult
```

## Example: Chat Interface

```gdscript
extends Control

var conversation_id: String = ""

func _ready():
    API.chat_response_received.connect(_on_chat_response)

func send_message(text: String):
    API.send_chat_message(text, conversation_id)

func _on_chat_response(response: Dictionary):
    conversation_id = response.get("conversation_id", "")
    display_message(response["message"])
```

## Example: Document List

```gdscript
extends Control

func _ready():
    API.documents_loaded.connect(_on_documents_loaded)
    API.list_documents(20, 0)

func _on_documents_loaded(documents: Array):
    for doc in documents:
        var title = doc.get("title", "Untitled")
        var authors = doc.get("authors", [])
        add_document_to_list(title, authors)
```

## Error Handling

```gdscript
func _ready():
    API.error_occurred.connect(_on_error)

func _on_error(message: String, code: int):
    match code:
        0: print("Connection failed")
        400: print("Bad request")
        404: print("Not found")
        500: print("Server error")
```

---

**Full Documentation**: See `client/scripts/api/README.md`
