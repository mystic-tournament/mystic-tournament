class_name UI
extends Control
# Contains all game UI


onready var _main_menu: MainMenu = $MainMenu
onready var _chat: Chat = $Chat
var _hud: HUD
var _scoreboard: Scoreboard


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


func _on_session_started() -> void:
	_main_menu.queue_free()
	_chat.move_upper()

	if CmdArguments.server:
		return

	_hud = preload("res://ui/hud/hud.tscn").instance()
	add_child(_hud)

	_scoreboard = preload("res://ui/scoreboard/scoreboard.tscn").instance()
	add_child(_scoreboard)
