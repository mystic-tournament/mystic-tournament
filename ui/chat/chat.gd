class_name Chat
extends VBoxContainer


onready var _input_field: LineEdit = $InputField
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _chat_window: RichTextLabel = $Panel/ChatWindow


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_announce_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_announce_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_display_message", ["gray", "You joined the game."])
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_display_message", ["gray", "You left the game."])
	# warning-ignore:return_value_discarded
	_input_field.connect("focus_exited", _animation_player, "play", ["hide_background"])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _input_field.has_focus():
			_input_field.accept_event()
			_input_field.release_focus()


func move_upper() -> void:
	_animation_player.play("move_upper")


func move_down() -> void:
	_animation_player.play("move_down")


master func _send_message(message: String) -> void:
	if message.empty():
		return
	rpc("_display_message", "white", "[[color=green]%d[/color]]: %s" % [get_tree().get_rpc_sender_id(), message])


puppetsync func _display_message(bbColor: String, message: String) -> void:
	if CmdArguments.server:
		print(_time(), " ", message)
	else:
		_chat_window.bbcode_text += "\n%s [color=%s]%s[/color]" % [_time(), bbColor, message]


func _write_message(message: String) -> void:
	if message.empty():
		return
	_input_field.clear()
	rpc("_send_message", message)


func _announce_connected(id: int) -> void:
	_display_message("yellow", "%d has joined the game." % id)


func _announce_disconnected(id: int) -> void:
	_display_message("yellow", "%d has left the game." % id)


func _time() -> String:
	var time: Dictionary = OS.get_time()
	var time_string: String = "[%02d:%02d:%02d]" % [time.hour, time.minute, time.second]
	if not CmdArguments.server:
		time_string = "[color=gray]" + time_string + "[/color]"
	return time_string
