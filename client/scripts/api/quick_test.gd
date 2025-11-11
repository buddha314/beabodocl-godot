## Quick API Test Script
## 
## Run this script to test API connectivity without the full test scene.
## Attach to any Node and run the scene.

extends Node

func _ready():
	print("\n" + "=".repeat(60))
	print("API CLIENT QUICK TEST")
	print("=".repeat(60) + "\n")
	
	print("Server URL: ", API.base_url)
	print("Testing connectivity...\n")
	
	# Connect to signals
	API.stats_loaded.connect(_on_stats)
	API.error_occurred.connect(_on_error)
	
	# Simple ping test
	API.get_stats()
	
	# Wait for response
	await get_tree().create_timer(3.0).timeout
	
	print("\nTest complete!")


func _on_stats(stats: Dictionary):
	print("✅ SERVER IS REACHABLE!\n")
	print("Server Statistics:")
	print("  📄 Total Documents: ", stats.get("total_documents", 0))
	print("  📚 Repositories: ", stats.get("repositories_count", 0))
	print("  💾 Storage Used (MB): ", stats.get("storage_used_mb", 0))
	print("  ⏱️  Uptime (seconds): ", stats.get("uptime_seconds", 0))
	print("  🔄 Last Updated: ", stats.get("last_updated", "N/A"))
	print()


func _on_error(message: String, code: int):
	print("❌ ERROR!")
	print("  Message: ", message)
	print("  Code: ", code)
	print()
	print("Make sure the babocument server is running:")
	print("  cd C:\\Users\\b\\src\\babocument")
	print("  python -m uvicorn app.main:app --reload")
	print()
