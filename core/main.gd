extends Node


var _hud: HUD
var _ingame_menu: IngameMenu
var _scoreboard: Scoreboard
var _fade_rect: FadeRect

onready var _ui: Control = $UI
onready var _main_menu: MainMenu = $UI/MainMenu
onready var _chat: Chat = $UI/Chat


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


func _on_session_started() -> void:
	_main_menu.queue_free()
	add_child(GameSession.map)

	# warning-ignore:return_value_discarded
	GameSession.gamemode.connect("game_over", self, "_on_game_over")

	if CmdArguments.server:
		return

	_hud = preload("res://ui/hud/hud.tscn").instance()
	_ui.add_child(_hud)

	_ingame_menu = preload("res://ui/ingame_menu/ingame_menu.tscn").instance()
	add_child(_ingame_menu)
	# warning-ignore:return_value_discarded
	_ingame_menu.connect("leave_pressed", self, "_leave_game")

	_scoreboard = preload("res://ui/scoreboard/scoreboard.tscn").instance()
	_ui.add_child(_scoreboard)

	_chat.move_upper()


# TODO 4.0: Unbind extra _winner argument
func _on_game_over(_winner) -> void:
	_fade_rect = preload("res://ui/fade_rect/fade_rect.tscn").instance()
	add_child(_fade_rect)
	_fade_rect.fade_out()
	yield(_fade_rect, "finished")

	if CmdArguments.server:
		get_tree().quit()
	get_tree().network_peer = null
	GameSession.clear()
	_hud.queue_free()
	_ingame_menu.queue_free()
	_scoreboard.show_final_score()
	_chat.move_down()
	_fade_rect.fade_in()
	yield(_fade_rect, "finished")

	_fade_rect.queue_free()
	yield(_scoreboard, "closed")

	_scoreboard.queue_free()
	_main_menu = preload("res://ui/main_menu/main_menu.tscn").instance()
	_ui.add_child(_main_menu)


func _leave_game() -> void:
	get_tree().network_peer = null
	GameSession.clear()
	_hud.queue_free()
	_ingame_menu.queue_free()
	_scoreboard.queue_free()
	_chat.move_down()
	_main_menu = preload("res://ui/main_menu/main_menu.tscn").instance()
	_ui.add_child(_main_menu)
