class_name ServerSettings
extends PanelContainer


signal teams_count_changed(count)
signal slots_count_changed(count)

onready var _teams_enabled: CheckBox = $VBox/TeamsEnabled
onready var _teams_count: SpinBox = $VBox/TeamsCount/SpinBox
onready var _slots_count: SpinBox = $VBox/SlotsCount/SpinBox
onready var _teams_count_box: HBoxContainer = $VBox/TeamsCount


func _ready():
	set_editable(false)
	_on_teams_toggled(_teams_enabled.pressed)

	# Allow to sync server configuration over network
	_teams_enabled.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	_slots_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	_teams_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_send_settings_to_peer")


func set_editable(editable: bool):
	_teams_enabled.disabled = !editable
	_slots_count.editable = editable
	_teams_count.editable = editable


func get_teams_count() -> int:
	if _teams_enabled.pressed:
		return int(_teams_count.value)
	return 1


func get_slots_count() -> int:
	return int(_slots_count.value)


func _on_teams_toggled(toggled: bool) -> void:
	_teams_count_box.visible = toggled
	_on_teams_count_changed(int(_teams_count.value) if toggled else 1)
	if get_tree().has_network_peer() and get_tree().is_network_server():
		_teams_enabled.rset("pressed", _teams_enabled.pressed)


func _on_teams_count_changed(count: int) -> void:
	emit_signal("teams_count_changed", count)
	if get_tree().has_network_peer() and get_tree().is_network_server():
		_teams_count.rset("value", _teams_count.value)


func _on_slots_count_changed(count: int) -> void:
	emit_signal("slots_count_changed", count)
	if get_tree().has_network_peer() and get_tree().is_network_server():
		_slots_count.rset("value", _slots_count.value)


func _send_settings_to_peer(id: int) -> void:
	if !get_tree().is_network_server():
		return
	_teams_enabled.rset_id(id, "pressed", _teams_enabled.pressed)
	_slots_count.rset_id(id, "value", _slots_count.value)
	_teams_count.rset_id(id, "value", _teams_count.value)
