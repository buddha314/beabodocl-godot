# API Client Documentation

## Overview

The API Client provides a complete interface for communicating with the babocument FastAPI backend server. It handles all HTTP requests, error handling, retry logic, and provides a clean async API using Godot signals.

## Installation

The API client is automatically loaded as a singleton named `API` when the project starts.

**Location**: `res://scripts/api/api_client.gd`  
**Autoload Name**: `API`

## Configuration

The API client can be configured through exported variables in the Godot inspector or via code:

```gdscript
# In project settings or at runtime
API.base_url = "http://localhost:8000"  # Default
API.request_timeout = 30.0  # seconds
API.max_retries = 3
API.retry_delay = 1.0  # seconds (exponential backoff)
API.debug_logging = true
```

## Basic Usage

### 1. Connect to Signals

All API methods are asynchronous and return results via signals:

```gdscript
extends Node

func _ready():
    # Connect to signals
    API.chat_response_received.connect(_on_chat_response)
    API.documents_loaded.connect(_on_documents_loaded)
    API.error_occurred.connect(_on_error)

func _on_chat_response(response: Dictionary):
    print("Agent says: ", response["message"])

func _on_documents_loaded(documents: Array):
    print("Loaded ", documents.size(), " documents")

func _on_error(error_message: String, error_code: int):
    print("Error: ", error_message)
```

### 2. Make API Calls

```gdscript
# Send a chat message
API.send_chat_message("What papers do you have?")

# List documents
API.list_documents(20, 0)  # limit, offset

# Search documents
API.search_documents("bioprinting", 10)

# Get specific document
API.get_document("doc_id_123")

# Get document content
API.get_document_content("doc_id_123")

# List repositories
API.list_repositories()

# Get system stats
API.get_stats()
```

## API Methods

### Agent API

#### `send_chat_message(message: String, conversation_id: String = "")`

Send a message to the AI agent.

**Parameters:**
- `message`: User's message text
- `conversation_id`: Optional conversation ID to continue a conversation

**Signal:** `chat_response_received(message: Dictionary)`

**Response Format:**
```gdscript
{
    "message": "Agent response text",
    "conversation_id": "uuid-string",
    "sources": [
        {
            "id": "doc_id",
            "title": "Paper Title",
            "relevance_score": 0.95
        }
    ],
    "metadata": {
        "model": "llama3",
        "response_time_ms": 1234
    }
}
```

**Example:**
```gdscript
func start_conversation():
    API.chat_response_received.connect(_on_chat_response)
    API.send_chat_message("What papers are about bioprinting?")

var conversation_id: String = ""

func _on_chat_response(response: Dictionary):
    conversation_id = response.get("conversation_id", "")
    print("Agent: ", response["message"])
    
    # Continue conversation
    API.send_chat_message("Tell me more about the first one", conversation_id)
```

---

### Documents API

#### `list_documents(limit: int = 20, offset: int = 0)`

Get a paginated list of all documents.

**Parameters:**
- `limit`: Maximum number of documents to return (default: 20)
- `offset`: Number of documents to skip (default: 0)

**Signal:** `documents_loaded(documents: Array)`

**Response Format:**
```gdscript
[
    {
        "id": "doc_123",
        "title": "Paper Title",
        "authors": ["Author 1", "Author 2"],
        "year": 2023,
        "source": "arXiv",
        "abstract": "...",
        "created_at": "2025-01-01T00:00:00"
    },
    ...
]
```

**Example:**
```gdscript
func load_documents_page(page: int):
    var limit = 20
    var offset = page * limit
    API.list_documents(limit, offset)

func _on_documents_loaded(documents: Array):
    for doc in documents:
        add_document_to_ui(doc)
```

---

#### `get_document(document_id: String)`

Get metadata for a specific document.

**Parameters:**
- `document_id`: The document's unique ID

**Signal:** `document_loaded(document: Dictionary)`

**Response Format:** Same as single item in `list_documents`

**Example:**
```gdscript
func load_document_details(doc_id: String):
    API.document_loaded.connect(_on_document_loaded)
    API.get_document(doc_id)

func _on_document_loaded(document: Dictionary):
    title_label.text = document["title"]
    authors_label.text = ", ".join(document["authors"])
```

---

#### `get_document_content(document_id: String)`

Get the full text content of a document.

**Parameters:**
- `document_id`: The document's unique ID

**Signal:** `document_content_loaded(content: String)`

**Example:**
```gdscript
func open_document(doc_id: String):
    API.document_content_loaded.connect(_on_content_loaded)
    API.get_document_content(doc_id)

func _on_content_loaded(content: String):
    text_display.text = content
```

---

#### `search_documents(query: String, limit: int = 20, offset: int = 0)`

Search documents using semantic search.

**Parameters:**
- `query`: Search query string
- `limit`: Maximum results to return
- `offset`: Number of results to skip

**Signal:** `search_results_received(results: Array)`

**Response Format:**
```gdscript
[
    {
        "document": {
            "id": "doc_123",
            "title": "...",
            ...
        },
        "score": 0.95,
        "highlights": ["matching text snippet 1", "snippet 2"]
    },
    ...
]
```

**Example:**
```gdscript
func search_papers(query_text: String):
    API.search_results_received.connect(_on_search_results)
    API.search_documents(query_text, 10)

func _on_search_results(results: Array):
    for result in results:
        var doc = result["document"]
        var score = result["score"]
        add_search_result_to_ui(doc, score)
```

---

### Repositories API

#### `list_repositories()`

Get a list of all document repositories.

**Signal:** `repositories_loaded(repositories: Array)`

**Response Format:**
```gdscript
[
    {
        "id": "repo_123",
        "name": "ArXiv Papers",
        "type": "arxiv",
        "path": "/path/to/repo",
        "document_count": 42,
        "status": "active",
        "last_sync": "2025-01-01T00:00:00"
    },
    ...
]
```

**Example:**
```gdscript
func load_repositories():
    API.repositories_loaded.connect(_on_repositories_loaded)
    API.list_repositories()

func _on_repositories_loaded(repositories: Array):
    for repo in repositories:
        print(repo["name"], ": ", repo["document_count"], " documents")
```

---

### Stats API

#### `get_stats()`

Get system statistics.

**Signal:** `stats_loaded(stats: Dictionary)`

**Response Format:**
```gdscript
{
    "total_documents": 100,
    "total_repositories": 3,
    "total_conversations": 50,
    "storage_used_bytes": 1073741824,
    "last_indexed": "2025-01-01T00:00:00",
    "version": "1.0.0",
    "uptime_seconds": 3600
}
```

**Example:**
```gdscript
func load_stats():
    API.stats_loaded.connect(_on_stats_loaded)
    API.get_stats()

func _on_stats_loaded(stats: Dictionary):
    document_count_label.text = str(stats["total_documents"])
    version_label.text = stats["version"]
```

---

## Error Handling

All errors are emitted via the `error_occurred` signal:

```gdscript
API.error_occurred.connect(_on_api_error)

func _on_api_error(error_message: String, error_code: int):
    match error_code:
        400:
            print("Bad request: ", error_message)
        404:
            print("Not found: ", error_message)
        500:
            print("Server error: ", error_message)
        0:
            print("Connection error: ", error_message)
        _:
            print("Error ", error_code, ": ", error_message)
```

### Automatic Retry

The API client automatically retries failed requests up to `max_retries` times with exponential backoff:

- **Retry on**: Connection errors, timeouts, 5xx server errors
- **No retry on**: 4xx client errors (bad request, not found, etc.)
- **Backoff**: `retry_delay * 2^retry_count` seconds

You can disable retries by setting `API.max_retries = 0`.

---

## Data Models

The API client includes data model classes for type safety. They are defined in `res://scripts/api/models.gd`.

### DocumentMetadata

```gdscript
var doc = DocumentMetadata.new({
    "id": "doc_123",
    "title": "Paper Title",
    "authors": ["Author 1"],
    "year": 2023
})

print(doc.title)  # "Paper Title"
print(doc.to_dict())  # Convert back to dictionary
```

### ChatMessage

```gdscript
var msg = ChatMessage.new({
    "role": "user",
    "content": "What papers do you have?",
    "timestamp": "2025-01-01T00:00:00"
})
```

### SearchQuery

```gdscript
var query = SearchQuery.new("bioprinting", 20, 0)
var params = query.to_dict()
# {"query": "bioprinting", "limit": 20, "offset": 0}
```

### RepositoryInfo

```gdscript
var repo = RepositoryInfo.new({
    "id": "repo_123",
    "name": "ArXiv",
    "type": "arxiv",
    "document_count": 42
})
```

### SystemStats

```gdscript
var stats = SystemStats.new({
    "total_documents": 100,
    "total_repositories": 3,
    "version": "1.0.0"
})
```

---

## Testing

### Quick Test

Run the test scene to verify API connectivity:

1. Make sure babocument server is running on `http://localhost:8000`
2. Open `res://api_test.tscn` in Godot
3. Run the scene (F6)
4. Check the console output for test results

### Test Script

You can also create your own test script:

```gdscript
extends Node

func _ready():
    API.ping()  # Simple connectivity check
    
    # Test chat
    API.chat_response_received.connect(func(response):
        print("Chat working! Response: ", response["message"])
    )
    API.send_chat_message("Hello!")
```

---

## Advanced Usage

### Changing Base URL

For remote servers or different environments:

```gdscript
# In a configuration script
func _ready():
    if OS.is_debug_build():
        API.set_base_url("http://localhost:8000")
    else:
        API.set_base_url("https://babocument.example.com")
```

### Request Queueing

The API client automatically manages concurrent requests to avoid overwhelming the server. You can adjust the limit:

```gdscript
# Access internal settings (advanced)
API._max_concurrent_requests = 5  # Allow more parallel requests
```

### Debug Logging

Enable detailed logging for troubleshooting:

```gdscript
API.debug_logging = true  # Enable
API.debug_logging = false  # Disable
```

---

## Common Patterns

### Chat Interface

```gdscript
extends Control

@onready var input_field = $InputField
@onready var chat_display = $ChatDisplay
var conversation_id: String = ""

func _ready():
    API.chat_response_received.connect(_on_chat_response)
    API.error_occurred.connect(_on_error)

func _on_send_button_pressed():
    var message = input_field.text
    if message.is_empty():
        return
    
    # Show user message
    add_message_to_ui("You", message)
    input_field.text = ""
    
    # Send to API
    API.send_chat_message(message, conversation_id)

func _on_chat_response(response: Dictionary):
    conversation_id = response.get("conversation_id", "")
    add_message_to_ui("Agent", response["message"])
```

### Document Browser

```gdscript
extends Control

var current_page: int = 0
var page_size: int = 20

func _ready():
    API.documents_loaded.connect(_on_documents_loaded)
    load_page(0)

func load_page(page: int):
    current_page = page
    API.list_documents(page_size, page * page_size)

func _on_documents_loaded(documents: Array):
    clear_document_list()
    for doc in documents:
        add_document_card(doc)

func _on_next_page_pressed():
    load_page(current_page + 1)

func _on_prev_page_pressed():
    if current_page > 0:
        load_page(current_page - 1)
```

### Search Interface

```gdscript
extends Control

@onready var search_input = $SearchInput
@onready var results_container = $ResultsContainer

func _ready():
    API.search_results_received.connect(_on_search_results)

func _on_search_button_pressed():
    var query = search_input.text
    if query.is_empty():
        return
    
    results_container.clear()
    API.search_documents(query, 20)

func _on_search_results(results: Array):
    for result in results:
        var doc = result["document"]
        var score = result["score"]
        add_result_card(doc, score)
```

---

## Troubleshooting

### Connection Errors

**Problem**: `error_occurred` signal fires with code 0

**Solutions:**
1. Check babocument server is running: `http://localhost:8000/docs`
2. Verify `API.base_url` is correct
3. Check firewall settings
4. Try `API.ping()` to test basic connectivity

### Timeout Errors

**Problem**: Requests timeout before completion

**Solutions:**
1. Increase timeout: `API.request_timeout = 60.0`
2. Check server performance
3. Reduce request size (lower `limit` parameter)

### JSON Parse Errors

**Problem**: "JSON parse error" in debug logs

**Solutions:**
1. Check server API version matches client expectations
2. Enable debug logging: `API.debug_logging = true`
3. Check raw response in console output
4. Verify server is returning valid JSON

### Missing Signals

**Problem**: No response from API calls

**Solutions:**
1. Ensure signals are connected before calling API methods
2. Check for errors via `error_occurred` signal
3. Verify server is running and accessible
4. Enable debug logging to see request/response details

---

## Performance Tips

1. **Pagination**: Always use pagination for large datasets
   ```gdscript
   API.list_documents(20, current_offset)  # Not: list_documents(1000)
   ```

2. **Debounce Search**: Don't search on every keystroke
   ```gdscript
   var search_timer: Timer
   func _on_search_text_changed(text: String):
       search_timer.start(0.5)  # Wait 0.5s before searching
   ```

3. **Cache Results**: Store frequently accessed data locally
   ```gdscript
   var document_cache: Dictionary = {}
   
   func get_cached_document(doc_id: String):
       if doc_id in document_cache:
           return document_cache[doc_id]
       else:
           API.get_document(doc_id)
   ```

4. **Disconnect Unused Signals**: Free up memory
   ```gdscript
   func _exit_tree():
       API.chat_response_received.disconnect(_on_chat_response)
   ```

---

## API Endpoint Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/agent/chat` | Send chat message to AI agent |
| GET | `/api/v1/documents` | List all documents (paginated) |
| GET | `/api/v1/documents/{id}` | Get document metadata |
| GET | `/api/v1/documents/{id}/content` | Get document full text |
| POST | `/api/v1/documents/search` | Search documents |
| GET | `/api/v1/repositories` | List repositories |
| GET | `/api/v1/stats` | Get system statistics |

Full API documentation: http://localhost:8000/docs

---

## License

Part of the beabodocl-godot project. See LICENSE file for details.
