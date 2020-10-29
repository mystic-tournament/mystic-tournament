extends HBoxContainer


var _peer := NetworkedMultiplayerENet.new()

onready var _servers: PanelContainer = $Servers
onready var _lobby: PanelContainer = $Lobby
onready var _teams_tree: TeamsTree = $Lobby/VBox/TeamsTree
onready var _leave_dialog: ConfirmationDialog = $Lobby/LeaveDialog
onready var _server_name_edit: LineEdit = $Lobby/VBox/Grid/ServerNameEdit
onready var _addresses_edit: LineEdit = $Lobby/VBox/Grid/AddressesEdit
onready var _port_spin: SpinBox = $Lobby/VBox/Grid/PortSpin
onready var _create_button: Button = $Lobby/VBox/CreateButton
onready var _start_game_button: Button = $Lobby/VBox/StartGameButton
onready var _server_settings: ServerSettings = $ServerSettings
onready var _direct_connect_dialog: DirectConnectDialog = $DirectConnectDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog
onready var _error_dialog: ErrorDialog = $ErrorDialog


func _init() -> void:
	# warning-ignore:return_value_discarded
	_peer.connect("connection_succeeded", self, "_on_joined")
	# warning-ignore:return_value_discarded
	_peer.connect("connection_failed", self, "_on_join_failed")
	# warning-ignore:return_value_discarded
	_peer.connect("server_disconnected", self, "_on_server_disconnected")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_peer.connect("peer_connected", _teams_tree, "add_connected_player")
	# warning-ignore:return_value_discarded
	_peer.connect("peer_disconnected", _teams_tree, "remove_disconnected_player")
	# warning-ignore:return_value_discarded
	_teams_tree.connect("filled_changed", _peer, "set_refuse_new_connections")
	# warning-ignore:return_value_discarded
	_teams_tree.connect("player_kicked", _peer, "disconnect_peer")


func back() -> void:
	if _lobby.visible:
		if get_tree().network_peer == null:
			# Lobby was not created
			_switch_to_servers()
			_server_settings.set_editable(false)
		else:
			_leave_dialog.popup_centered()
		return

	hide()


func _create_lobby() -> void:
	# TODO: Display all addresses here
	_server_settings.set_editable(true)
	_addresses_edit.text = IP.get_local_addresses().front()
	_port_spin.editable = true
	_server_name_edit.editable = true
	_create_button.visible = true
	_start_game_button.visible = false

	_switch_to_lobby()


func _direct_join_lobby() -> void:
	var address: String = _direct_connect_dialog.address
	var port: int = _direct_connect_dialog.port

	if _peer.create_client(address, port) != OK:
		_error_dialog.show_error("Unable to create connection")
		return

	get_tree().network_peer = _peer
	_connection_dialog.show_connecting(address, port)


func _cancel_connection() -> void:
	_peer.close_connection()
	get_tree().network_peer = null


func _on_joined() -> void:
	_port_spin.editable = false
	_server_name_edit.editable = false
	_create_button.visible = false
	_start_game_button.visible = false
	_switch_to_lobby()


func _on_join_failed() -> void:
	get_tree().network_peer = null
	_error_dialog.show_error("Unable to join lobby")


func _on_server_disconnected() -> void:
	_switch_to_servers()
	get_tree().network_peer = null
	_leave_dialog.hide()
	_error_dialog.show_error("Server was disconnected")


func _confirm_creation():
	if _peer.create_server(int(_port_spin.value)) != OK:
		_error_dialog.show_error("Unable to create server")
		return

	get_tree().network_peer = _peer
	_port_spin.editable = false
	_server_name_edit.editable = false
	_create_button.visible = false
	_start_game_button.visible = true


	_teams_tree.create(_server_settings.get_teams_count(), _server_settings.get_slots_count())
	# warning-ignore:return_value_discarded
	_server_settings.connect("teams_count_changed", _teams_tree, "set_teams_count")
	# warning-ignore:return_value_discarded
	_server_settings.connect("slots_count_changed", _teams_tree, "set_slots_count")


func _confirm_leave() -> void:
	if get_tree().is_network_server():
		_server_settings.disconnect("teams_count_changed", _teams_tree, "set_teams_count")
		_server_settings.disconnect("slots_count_changed", _teams_tree, "set_slots_count")
		_server_settings.set_editable(false)

	_cancel_connection()
	_switch_to_servers()


func _switch_to_lobby() -> void:
	_servers.visible = false
	_lobby.visible = true


func _switch_to_servers() -> void:
	_teams_tree.clear()
	_servers.visible = true
	_lobby.visible = false


func _start_game() -> void:
	Gamemode.rpc("start_game")
