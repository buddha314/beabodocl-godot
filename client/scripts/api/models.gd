## API Data Models
##
## This file contains all data model classes used for API communication
## with the babocument backend server.

extends Node

## Document metadata returned from /api/v1/documents endpoints
class_name DocumentMetadata

var id: String = ""
var title: String = ""
var authors: Array[String] = []
var year: int = 0
var source: String = ""
var abstract: String = ""
var created_at: String = ""
var updated_at: String = ""
var file_path: String = ""
var file_size: int = 0

func _init(data: Dictionary = {}):
	if data.has("id"):
		id = data.get("id", "")
	if data.has("title"):
		title = data.get("title", "")
	if data.has("authors"):
		var author_data = data.get("authors", [])
		if author_data is Array:
			for author in author_data:
				if author is String:
					authors.append(author)
	if data.has("year"):
		year = data.get("year", 0)
	if data.has("source"):
		source = data.get("source", "")
	if data.has("abstract"):
		abstract = data.get("abstract", "")
	if data.has("created_at"):
		created_at = data.get("created_at", "")
	if data.has("updated_at"):
		updated_at = data.get("updated_at", "")
	if data.has("file_path"):
		file_path = data.get("file_path", "")
	if data.has("file_size"):
		file_size = data.get("file_size", 0)

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"authors": authors,
		"year": year,
		"source": source,
		"abstract": abstract,
		"created_at": created_at,
		"updated_at": updated_at,
		"file_path": file_path,
		"file_size": file_size
	}


## Chat message for agent conversations
class ChatMessage:
	var role: String = ""  # "user" or "agent" or "system"
	var content: String = ""
	var timestamp: String = ""
	var sources: Array = []  # Optional citations
	var conversation_id: String = ""
	var metadata: Dictionary = {}
	
	func _init(data: Dictionary = {}):
		role = data.get("role", "")
		content = data.get("content", "")
		timestamp = data.get("timestamp", Time.get_datetime_string_from_system())
		
		if data.has("sources"):
			var source_data = data.get("sources", [])
			if source_data is Array:
				sources = source_data
		
		if data.has("conversation_id"):
			conversation_id = data.get("conversation_id", "")
		
		if data.has("metadata"):
			metadata = data.get("metadata", {})
	
	func to_dict() -> Dictionary:
		return {
			"role": role,
			"content": content,
			"timestamp": timestamp,
			"sources": sources,
			"conversation_id": conversation_id,
			"metadata": metadata
		}


## Search query parameters
class SearchQuery:
	var query: String = ""
	var limit: int = 20
	var offset: int = 0
	var filters: Dictionary = {}
	var sort_by: String = "relevance"  # "relevance", "date", "title"
	
	func _init(search_query: String = "", search_limit: int = 20, search_offset: int = 0):
		query = search_query
		limit = search_limit
		offset = search_offset
	
	func to_dict() -> Dictionary:
		var result = {
			"query": query,
			"limit": limit,
			"offset": offset,
			"sort_by": sort_by
		}
		
		if not filters.is_empty():
			result["filters"] = filters
		
		return result


## Repository information
class RepositoryInfo:
	var id: String = ""
	var name: String = ""
	var type: String = ""  # "local", "arxiv", "pubmed", etc.
	var path: String = ""
	var document_count: int = 0
	var status: String = ""  # "active", "indexing", "error"
	var last_sync: String = ""
	var created_at: String = ""
	
	func _init(data: Dictionary = {}):
		id = data.get("id", "")
		name = data.get("name", "")
		type = data.get("type", "")
		path = data.get("path", "")
		document_count = data.get("document_count", 0)
		status = data.get("status", "")
		last_sync = data.get("last_sync", "")
		created_at = data.get("created_at", "")
	
	func to_dict() -> Dictionary:
		return {
			"id": id,
			"name": name,
			"type": type,
			"path": path,
			"document_count": document_count,
			"status": status,
			"last_sync": last_sync,
			"created_at": created_at
		}


## System statistics
class SystemStats:
	var total_documents: int = 0
	var total_repositories: int = 0
	var total_conversations: int = 0
	var storage_used_bytes: int = 0
	var last_indexed: String = ""
	var version: String = ""
	var uptime_seconds: int = 0
	
	func _init(data: Dictionary = {}):
		total_documents = data.get("total_documents", 0)
		total_repositories = data.get("total_repositories", 0)
		total_conversations = data.get("total_conversations", 0)
		storage_used_bytes = data.get("storage_used_bytes", 0)
		last_indexed = data.get("last_indexed", "")
		version = data.get("version", "")
		uptime_seconds = data.get("uptime_seconds", 0)
	
	func to_dict() -> Dictionary:
		return {
			"total_documents": total_documents,
			"total_repositories": total_repositories,
			"total_conversations": total_conversations,
			"storage_used_bytes": storage_used_bytes,
			"last_indexed": last_indexed,
			"version": version,
			"uptime_seconds": uptime_seconds
		}


## Document content (full text)
class DocumentContent:
	var id: String = ""
	var content: String = ""
	var format: String = "text"  # "text", "markdown", "html"
	var metadata: DocumentMetadata
	
	func _init(data: Dictionary = {}):
		id = data.get("id", "")
		content = data.get("content", "")
		format = data.get("format", "text")
		
		if data.has("metadata"):
			metadata = DocumentMetadata.new(data.get("metadata", {}))
	
	func to_dict() -> Dictionary:
		var result = {
			"id": id,
			"content": content,
			"format": format
		}
		
		if metadata:
			result["metadata"] = metadata.to_dict()
		
		return result


## Search result item
class SearchResult:
	var document: DocumentMetadata
	var score: float = 0.0
	var highlights: Array[String] = []
	
	func _init(data: Dictionary = {}):
		if data.has("document"):
			document = DocumentMetadata.new(data.get("document", {}))
		
		score = data.get("score", 0.0)
		
		if data.has("highlights"):
			var highlight_data = data.get("highlights", [])
			if highlight_data is Array:
				for highlight in highlight_data:
					if highlight is String:
						highlights.append(highlight)
	
	func to_dict() -> Dictionary:
		var result = {
			"score": score,
			"highlights": highlights
		}
		
		if document:
			result["document"] = document.to_dict()
		
		return result
