extends Node


const HudScene: PackedScene = preload("res://ui/hud/hud.tscn")
const IngameMenuScene: PackedScene = preload("res://ui/ingame_menu/ingame_menu.tscn")
const ScoreboardScene: PackedScene = preload("res://ui/scoreboard/scoreboard.tscn")
const FadeRectScene: PackedScene = preload("res://ui/fade_rect/fade_rect.tscn")
const MainMenuScene: PackedScene = preload("res://ui/main_menu/main_menu.tscn")

var _hud: HUD
var _ingame_menu: IngameMenu
var _scoreboard: Scoreboard
var _fade_rect: FadeRect

onready var _ui: Control = $UI
onready var _error_dialog: ErrorDialog = $UI/ErrorDialog
onready var _main_menu: MainMenu = $UI/MainMenu
onready var _chat: Chat = $UI/Chat


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


func _on_session_started() -> void:
	_main_menu.queue_free()
	add_child(GameSession.map)

	# warning-ignore:return_value_discarded
	GameSession.gamemode.connect("game_over", self, "_end_game")

	if CmdArguments.server:
		return

	# warning-ignore:return_value_discarded
	get_tree().network_peer.connect("server_disconnected", self, "_on_server_disconnected", [], CONNECT_DEFERRED)

	_hud = HudScene.instance()
	_ui.add_child(_hud)

	_ingame_menu = IngameMenuScene.instance()
	add_child(_ingame_menu)
	# warning-ignore:return_value_discarded
	_ingame_menu.connect("leave_pressed", self, "_end_game")

	_scoreboard = ScoreboardScene.instance()
	_ui.add_child(_scoreboard)

	_chat.move_upper()


# Show animation and scoreboard on normal termination (winner != null), otherwise just close the game session
func _end_game(winner = null) -> void:
	if winner:
		_fade_rect = FadeRectScene.instance()
		add_child(_fade_rect)
		_fade_rect.fade_out()
		yield(_fade_rect, "finished")

	if CmdArguments.server:
		get_tree().quit()
	else:
		get_tree().network_peer.disconnect("server_disconnected", self, "_on_server_disconnected")
	get_tree().network_peer = null
	GameSession.clear()
	_hud.queue_free()
	_ingame_menu.queue_free()
	_chat.move_down()

	if winner:
		_scoreboard.show_final_score()
		_fade_rect.fade_in()
		yield(_fade_rect, "finished")
		_fade_rect.queue_free()
		yield(_scoreboard, "closed")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_scoreboard.queue_free()
	_main_menu = MainMenuScene.instance()
	_ui.add_child(_main_menu)


func _on_server_disconnected() -> void:
	_end_game()
	_error_dialog.show_error("You have been disconnected from the server")
