## Simple Chat Integration Example
##
## This shows how to integrate the API client into a basic chat UI.
## Use this as a reference when building the actual VR chat panel.

extends Control

# UI References
@onready var chat_display: RichTextLabel = $VBoxContainer/ChatDisplay
@onready var input_field: LineEdit = $VBoxContainer/InputContainer/InputField
@onready var send_button: Button = $VBoxContainer/InputContainer/SendButton
@onready var typing_indicator: Label = $VBoxContainer/TypingIndicator

# State
var conversation_id: String = ""
var is_waiting: bool = false

func _ready():
	# Connect UI signals
	send_button.pressed.connect(_on_send_button_pressed)
	input_field.text_submitted.connect(_on_input_submitted)
	
	# Connect API signals
	API.chat_response_received.connect(_on_chat_response)
	API.error_occurred.connect(_on_api_error)
	
	# Initialize
	typing_indicator.visible = false
	add_system_message("Connected to babocument server")


## Send message when button clicked
func _on_send_button_pressed() -> void:
	_send_message()


## Send message when Enter pressed
func _on_input_submitted(text: String) -> void:
	_send_message()


## Send the message to API
func _send_message() -> void:
	var message = input_field.text.strip_edges()
	
	# Validate
	if message.is_empty():
		return
	
	if is_waiting:
		add_system_message("Please wait for response...")
		return
	
	# Clear input
	input_field.text = ""
	
	# Display user message
	add_user_message(message)
	
	# Show typing indicator
	is_waiting = true
	typing_indicator.visible = true
	send_button.disabled = true
	
	# Send to API
	API.send_chat_message(message, conversation_id)


## Handle chat response from API
func _on_chat_response(response: Dictionary) -> void:
	# Hide typing indicator
	is_waiting = false
	typing_indicator.visible = false
	send_button.disabled = false
	
	# Update conversation ID
	if response.has("conversation_id"):
		conversation_id = response.get("conversation_id", "")
	
	# Display agent message
	var message = response.get("message", "")
	add_agent_message(message)
	
	# Display sources if available
	if response.has("sources") and not response["sources"].is_empty():
		var sources = response["sources"]
		add_sources(sources)


## Handle API errors
func _on_api_error(error_message: String, error_code: int) -> void:
	is_waiting = false
	typing_indicator.visible = false
	send_button.disabled = false
	
	add_system_message("Error: " + error_message)


## Add user message to display
func add_user_message(message: String) -> void:
	chat_display.append_text("[color=cyan][b]You:[/b][/color] ")
	chat_display.append_text(message)
	chat_display.append_text("\n\n")
	_scroll_to_bottom()


## Add agent message to display
func add_agent_message(message: String) -> void:
	chat_display.append_text("[color=lime][b]Agent:[/b][/color] ")
	chat_display.append_text(message)
	chat_display.append_text("\n\n")
	_scroll_to_bottom()


## Add system message to display
func add_system_message(message: String) -> void:
	chat_display.append_text("[color=gray][i]" + message + "[/i][/color]\n\n")
	_scroll_to_bottom()


## Add sources to display
func add_sources(sources: Array) -> void:
	chat_display.append_text("[color=yellow][i]Sources:[/i][/color]\n")
	for source in sources:
		var title = source.get("title", "Unknown")
		var score = source.get("relevance_score", 0.0)
		chat_display.append_text("  • " + title + " (")
		chat_display.append_text(str(snapped(score, 0.01)))
		chat_display.append_text(")\n")
	chat_display.append_text("\n")
	_scroll_to_bottom()


## Scroll chat display to bottom
func _scroll_to_bottom() -> void:
	await get_tree().process_frame
	chat_display.scroll_to_line(chat_display.get_line_count())
