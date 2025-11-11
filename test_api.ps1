# PowerShell API Test Script
# Tests the babocument API endpoints directly

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "BABOCUMENT API TEST" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$baseUrl = "http://localhost:8000"

# Test 1: Server Stats
Write-Host "Test 1: GET /api/v1/stats" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/v1/stats" -Method Get
    Write-Host "✅ SUCCESS" -ForegroundColor Green
    Write-Host "  Total Documents: $($response.total_documents)"
    Write-Host "  Repositories: $($response.repositories_count)"
    Write-Host "  Storage (MB): $($response.storage_used_mb)"
    Write-Host "  Uptime (s): $($response.uptime_seconds)"
} catch {
    Write-Host "❌ FAILED: $_" -ForegroundColor Red
}
Write-Host ""

# Test 2: List Repositories
Write-Host "Test 2: GET /api/v1/repositories" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/v1/repositories" -Method Get
    Write-Host "✅ SUCCESS" -ForegroundColor Green
    Write-Host "  Found $($response.Count) repositories"
    foreach ($repo in $response) {
        Write-Host "  - $($repo.name) ($($repo.type)): $($repo.document_count) docs"
    }
} catch {
    Write-Host "❌ FAILED: $_" -ForegroundColor Red
}
Write-Host ""

# Test 3: List Documents
Write-Host "Test 3: GET /api/v1/documents?limit=5" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/v1/documents?limit=5&offset=0" -Method Get
    Write-Host "✅ SUCCESS" -ForegroundColor Green
    Write-Host "  Found $($response.Count) documents"
    foreach ($doc in $response) {
        Write-Host "  - $($doc.title)"
    }
} catch {
    Write-Host "❌ FAILED: $_" -ForegroundColor Red
}
Write-Host ""

# Test 4: Search Documents
Write-Host "Test 4: POST /api/v1/documents/search" -ForegroundColor Yellow
try {
    $searchBody = @{
        query = "bioprinting"
        limit = 3
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/api/v1/documents/search" -Method Post -Body $searchBody -ContentType "application/json"
    Write-Host "✅ SUCCESS" -ForegroundColor Green
    Write-Host "  Found $($response.Count) results"
    foreach ($result in $response) {
        $score = [math]::Round($result.score, 3)
        Write-Host "  - $($result.document.title) (score: $score)"
    }
} catch {
    Write-Host "❌ FAILED: $_" -ForegroundColor Red
}
Write-Host ""

# Test 5: Agent Chat
Write-Host "Test 5: POST /api/v1/agent/chat" -ForegroundColor Yellow
try {
    $chatBody = @{
        message = "What papers do you have?"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/api/v1/agent/chat" -Method Post -Body $chatBody -ContentType "application/json"
    Write-Host "✅ SUCCESS" -ForegroundColor Green
    Write-Host "  Conversation ID: $($response.conversation_id)"
    Write-Host "  Response: $($response.message.Substring(0, [Math]::Min(100, $response.message.Length)))..."
    if ($response.sources) {
        Write-Host "  Sources: $($response.sources.Count) documents cited"
    }
} catch {
    Write-Host "❌ FAILED: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "API TEST COMPLETE" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Next: Open Godot and run one of these scenes:" -ForegroundColor Yellow
Write-Host "  - res://quick_test.tscn (simple connectivity test)"
Write-Host "  - res://api_test.tscn (comprehensive API test)`n"
