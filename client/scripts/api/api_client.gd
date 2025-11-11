## API Client
##
## Singleton for communicating with the babocument FastAPI backend.
## Provides methods for all API endpoints with error handling and retry logic.
##
## Usage:
##   API.send_chat_message("What papers do you have?")
##   API.list_documents(20, 0)
##   API.search_documents("bioprinting")

extends Node

## Base URL for the babocument API server
@export var base_url: String = "http://localhost:8000"

## Request timeout in seconds
@export var request_timeout: float = 30.0

## Maximum number of retry attempts
@export var max_retries: int = 3

## Retry delay in seconds (exponential backoff)
@export var retry_delay: float = 1.0

## Enable debug logging
@export var debug_logging: bool = true

## Signals for async responses
signal chat_response_received(message: Dictionary)
signal documents_loaded(documents: Array)
signal document_loaded(document: Dictionary)
signal document_content_loaded(content: String)
signal search_results_received(results: Array)
signal repositories_loaded(repositories: Array)
signal stats_loaded(stats: Dictionary)
signal error_occurred(error_message: String, error_code: int)

## Internal state
var _active_requests: Dictionary = {}  # Track active HTTPRequest nodes
var _request_queue: Array = []  # Queue for pending requests
var _max_concurrent_requests: int = 3


func _ready():
	if debug_logging:
		print("[API] APIClient initialized - Base URL: ", base_url)


## ============================================================================
## AGENT API
## ============================================================================

## Send a chat message to the AI agent
## @param message: The user's message
## @param conversation_id: Optional conversation ID to continue a conversation
func send_chat_message(message: String, conversation_id: String = "") -> void:
	if message.is_empty():
		_emit_error("Message cannot be empty", 400)
		return
	
	var body = {"message": message}
	if not conversation_id.is_empty():
		body["conversation_id"] = conversation_id
	
	_make_request(
		"/api/v1/agent/chat",
		HTTPClient.METHOD_POST,
		body,
		_on_chat_response
	)


func _on_chat_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null:
			chat_response_received.emit(json_result)
		else:
			_emit_error("Failed to parse chat response", response_code)
	else:
		_emit_error("Chat request failed", response_code)


## ============================================================================
## DOCUMENTS API
## ============================================================================

## List all documents with pagination
## @param limit: Maximum number of documents to return
## @param offset: Number of documents to skip
func list_documents(limit: int = 20, offset: int = 0) -> void:
	var query_params = "?limit=" + str(limit) + "&offset=" + str(offset)
	
	_make_request(
		"/api/v1/documents" + query_params,
		HTTPClient.METHOD_GET,
		{},
		_on_documents_loaded
	)


func _on_documents_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null and json_result is Array:
			documents_loaded.emit(json_result)
		else:
			_emit_error("Failed to parse documents list", response_code)
	else:
		_emit_error("Documents list request failed", response_code)


## Get metadata for a specific document
## @param document_id: The ID of the document
func get_document(document_id: String) -> void:
	if document_id.is_empty():
		_emit_error("Document ID cannot be empty", 400)
		return
	
	_make_request(
		"/api/v1/documents/" + document_id,
		HTTPClient.METHOD_GET,
		{},
		_on_document_loaded
	)


func _on_document_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null:
			document_loaded.emit(json_result)
		else:
			_emit_error("Failed to parse document metadata", response_code)
	else:
		_emit_error("Document metadata request failed", response_code)


## Get full content of a document
## @param document_id: The ID of the document
func get_document_content(document_id: String) -> void:
	if document_id.is_empty():
		_emit_error("Document ID cannot be empty", 400)
		return
	
	_make_request(
		"/api/v1/documents/" + document_id + "/content",
		HTTPClient.METHOD_GET,
		{},
		_on_document_content_loaded
	)


func _on_document_content_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null:
			# Extract content string from response
			var content = json_result.get("content", "")
			document_content_loaded.emit(content)
		else:
			_emit_error("Failed to parse document content", response_code)
	else:
		_emit_error("Document content request failed", response_code)


## Search documents
## @param query: Search query string
## @param limit: Maximum number of results
## @param offset: Number of results to skip
func search_documents(query: String, limit: int = 20, offset: int = 0) -> void:
	if query.is_empty():
		_emit_error("Search query cannot be empty", 400)
		return
	
	var body = {
		"query": query,
		"limit": limit,
		"offset": offset
	}
	
	_make_request(
		"/api/v1/documents/search",
		HTTPClient.METHOD_POST,
		body,
		_on_search_results_received
	)


func _on_search_results_received(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null and json_result is Array:
			search_results_received.emit(json_result)
		else:
			_emit_error("Failed to parse search results", response_code)
	else:
		_emit_error("Search request failed", response_code)


## ============================================================================
## REPOSITORIES API
## ============================================================================

## List all repositories
func list_repositories() -> void:
	_make_request(
		"/api/v1/repositories",
		HTTPClient.METHOD_GET,
		{},
		_on_repositories_loaded
	)


func _on_repositories_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null and json_result is Array:
			repositories_loaded.emit(json_result)
		else:
			_emit_error("Failed to parse repositories list", response_code)
	else:
		_emit_error("Repositories list request failed", response_code)


## ============================================================================
## STATS API
## ============================================================================

## Get system statistics
func get_stats() -> void:
	_make_request(
		"/api/v1/stats",
		HTTPClient.METHOD_GET,
		{},
		_on_stats_loaded
	)


func _on_stats_loaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_result = _parse_json(body)
		if json_result != null:
			stats_loaded.emit(json_result)
		else:
			_emit_error("Failed to parse stats", response_code)
	else:
		_emit_error("Stats request failed", response_code)


## ============================================================================
## INTERNAL HELPERS
## ============================================================================

## Make an HTTP request with retry logic
func _make_request(
	endpoint: String,
	method: HTTPClient.Method,
	body: Dictionary,
	callback: Callable,
	retry_count: int = 0
) -> void:
	# Create HTTPRequest node
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Configure timeout
	http_request.timeout = request_timeout
	
	# Connect completion signal
	http_request.request_completed.connect(
		func(result, response_code, headers, response_body):
			_handle_response(result, response_code, headers, response_body, callback, endpoint, method, body, retry_count, http_request)
	)
	
	# Prepare headers
	var headers_array = ["Content-Type: application/json"]
	
	# Prepare body
	var body_string = ""
	if not body.is_empty():
		body_string = JSON.stringify(body)
	
	# Make request
	var url = base_url + endpoint
	
	if debug_logging:
		var method_name = "UNKNOWN"
		match method:
			HTTPClient.METHOD_GET: method_name = "GET"
			HTTPClient.METHOD_POST: method_name = "POST"
			HTTPClient.METHOD_PUT: method_name = "PUT"
			HTTPClient.METHOD_DELETE: method_name = "DELETE"
		print("[API] Request: ", method_name, " ", url)
		if not body.is_empty():
			print("[API] Body: ", body_string)
	
	var error = http_request.request(url, headers_array, method, body_string)
	
	if error != OK:
		_emit_error("Failed to create HTTP request: " + str(error), 0)
		http_request.queue_free()
		return
	
	# Track active request
	_active_requests[http_request] = {
		"endpoint": endpoint,
		"method": method,
		"body": body,
		"callback": callback,
		"retry_count": retry_count
	}


## Handle HTTP response and implement retry logic
func _handle_response(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray,
	callback: Callable,
	endpoint: String,
	method: HTTPClient.Method,
	request_body: Dictionary,
	retry_count: int,
	http_request: HTTPRequest
) -> void:
	
	if debug_logging:
		print("[API] Response: ", response_code, " for ", endpoint)
	
	# Remove from active requests
	if http_request in _active_requests:
		_active_requests.erase(http_request)
	
	# Check if we should retry
	var should_retry = false
	
	if result != HTTPRequest.RESULT_SUCCESS:
		if debug_logging:
			print("[API] Request failed with result code: ", result)
		should_retry = true
	elif response_code >= 500:
		if debug_logging:
			print("[API] Server error: ", response_code)
		should_retry = true
	elif response_code == 0:
		if debug_logging:
			print("[API] Connection failed")
		should_retry = true
	
	# Retry if needed
	if should_retry and retry_count < max_retries:
		if debug_logging:
			print("[API] Retrying request (attempt ", retry_count + 1, "/", max_retries, ")")
		
		# Clean up current request
		http_request.queue_free()
		
		# Schedule retry with exponential backoff
		var delay = retry_delay * pow(2, retry_count)
		await get_tree().create_timer(delay).timeout
		
		_make_request(endpoint, method, request_body, callback, retry_count + 1)
		return
	
	# Call the callback
	callback.call(result, response_code, headers, body)
	
	# Clean up request node
	http_request.queue_free()


## Parse JSON from response body
func _parse_json(body: PackedByteArray) -> Variant:
	var json_string = body.get_string_from_utf8()
	
	if json_string.is_empty():
		if debug_logging:
			print("[API] Empty response body")
		return null
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		if debug_logging:
			print("[API] JSON parse error at line ", json.get_error_line(), ": ", json.get_error_message())
			print("[API] Response: ", json_string)
		return null
	
	return json.data


## Emit error signal
func _emit_error(message: String, code: int) -> void:
	if debug_logging:
		print("[API] Error: ", message, " (", code, ")")
	
	error_occurred.emit(message, code)


## Check if server is reachable
func ping() -> void:
	_make_request(
		"/api/v1/stats",
		HTTPClient.METHOD_GET,
		{},
		func(result, response_code, headers, body):
			if response_code == 200:
				print("[API] Server is reachable")
			else:
				print("[API] Server is not reachable (code: ", response_code, ")")
	)


## Set base URL (useful for testing or remote servers)
func set_base_url(url: String) -> void:
	base_url = url
	if debug_logging:
		print("[API] Base URL changed to: ", base_url)
