## API Client Test Scene
##
## Simple test script to verify API connectivity and methods
## Attach to a Node in a test scene and run

extends Node

func _ready():
	print("\n=== API Client Test ===\n")
	
	# Connect to signals
	API.chat_response_received.connect(_on_chat_response)
	API.documents_loaded.connect(_on_documents_loaded)
	API.document_loaded.connect(_on_document_loaded)
	API.document_content_loaded.connect(_on_document_content_loaded)
	API.search_results_received.connect(_on_search_results)
	API.repositories_loaded.connect(_on_repositories_loaded)
	API.stats_loaded.connect(_on_stats_loaded)
	API.error_occurred.connect(_on_error)
	
	print("API Client initialized with base URL: ", API.base_url)
	print("\nStarting tests...\n")
	
	# Test 1: Ping server
	print("Test 1: Ping server")
	API.ping()
	await get_tree().create_timer(2.0).timeout
	
	# Test 2: Get stats
	print("\nTest 2: Get system stats")
	API.get_stats()
	await get_tree().create_timer(2.0).timeout
	
	# Test 3: List repositories
	print("\nTest 3: List repositories")
	API.list_repositories()
	await get_tree().create_timer(2.0).timeout
	
	# Test 4: List documents
	print("\nTest 4: List documents (limit 5)")
	API.list_documents(5, 0)
	await get_tree().create_timer(2.0).timeout
	
	# Test 5: Search documents
	print("\nTest 5: Search documents for 'bioprinting'")
	API.search_documents("bioprinting", 3, 0)
	await get_tree().create_timer(2.0).timeout
	
	# Test 6: Send chat message
	print("\nTest 6: Send chat message")
	API.send_chat_message("What papers do you have?")
	await get_tree().create_timer(3.0).timeout
	
	print("\n=== Tests Complete ===\n")


func _on_chat_response(response: Dictionary):
	print("[✓] Chat Response Received:")
	print("  Message: ", response.get("message", "N/A"))
	print("  Conversation ID: ", response.get("conversation_id", "N/A"))
	if response.has("sources"):
		print("  Sources: ", response.get("sources", []).size(), " items")


func _on_documents_loaded(documents: Array):
	print("[✓] Documents Loaded: ", documents.size(), " documents")
	for i in range(min(3, documents.size())):
		var doc = documents[i]
		print("  - ", doc.get("title", "Untitled"))


func _on_document_loaded(document: Dictionary):
	print("[✓] Document Loaded:")
	print("  Title: ", document.get("title", "N/A"))
	print("  ID: ", document.get("id", "N/A"))


func _on_document_content_loaded(content: String):
	print("[✓] Document Content Loaded: ", content.length(), " characters")
	print("  Preview: ", content.substr(0, 100), "...")


func _on_search_results(results: Array):
	print("[✓] Search Results Received: ", results.size(), " results")
	for i in range(min(3, results.size())):
		var result = results[i]
		var doc = result.get("document", {})
		print("  - ", doc.get("title", "Untitled"), " (score: ", result.get("score", 0), ")")


func _on_repositories_loaded(repositories: Array):
	print("[✓] Repositories Loaded: ", repositories.size(), " repositories")
	for i in range(min(3, repositories.size())):
		var repo = repositories[i]
		print("  - ", repo.get("name", "Unnamed"), " (", repo.get("type", "unknown"), ")")


func _on_stats_loaded(stats: Dictionary):
	print("[✓] Stats Loaded:")
	print("  Total Documents: ", stats.get("total_documents", 0))
	print("  Total Repositories: ", stats.get("total_repositories", 0))
	print("  Version: ", stats.get("version", "N/A"))


func _on_error(error_message: String, error_code: int):
	print("[✗] Error: ", error_message, " (code: ", error_code, ")")
