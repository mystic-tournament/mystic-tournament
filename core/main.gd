extends Node


const HudScene: PackedScene = preload("res://ui/game_session/hud/hud.tscn")
const IngameMenuScene: PackedScene = preload("res://ui/game_session/ingame_menu.tscn")
const ScoreboardScene: PackedScene = preload("res://ui/game_session/scoreboard/scoreboard.tscn")
const FadeRectScene: PackedScene = preload("res://ui/fade_rect.tscn")
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

	if CmdArguments.server:
		# warning-ignore:return_value_discarded
		GameSession.gamemode.connect("game_over", self, "_wait_for_peers_and_shutdown")
		return

	# warning-ignore:return_value_discarded
	GameSession.gamemode.connect("game_over", self, "_end_session")

	# warning-ignore:return_value_discarded
	get_tree().network_peer.connect("server_disconnected", self, "_on_server_disconnected")

	_hud = HudScene.instance()
	_ui.add_child(_hud)

	_ingame_menu = IngameMenuScene.instance()
	add_child(_ingame_menu)
	# warning-ignore:return_value_discarded
	_ingame_menu.connect("leave_pressed", self, "_end_session")

	_scoreboard = ScoreboardScene.instance()
	_ui.add_child(_scoreboard)

	_chat.move_upper()


# Show animation and scoreboard on normal termination (winner != null), otherwise just close the game session
func _end_session(winner = null) -> void:
	if winner:
		_fade_rect = FadeRectScene.instance()
		add_child(_fade_rect)
		_fade_rect.fade_out()
		yield(_fade_rect, "finished")

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
	_end_session()
	_error_dialog.show_error("You have been disconnected from the server")


# TODO 4.0: Unbind extra _winner
func _wait_for_peers_and_shutdown(_winner) -> void:
	while not get_tree().get_network_connected_peers().empty():
		yield(get_tree().network_peer, "peer_disconnected")
	get_tree().quit()
