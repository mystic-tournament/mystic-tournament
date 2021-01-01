class_name TeamsTree
extends Tree


signal filled_changed(is_full)
signal player_kicked(id)

var _teams: Array
var _teams_full: bool


func _ready() -> void:
	# warning-ignore:return_value_discarded
	create_item() # Create root
	# warning-ignore:return_value_discarded
	connect("button_pressed", self, "_on_button_pressed")
	# warning-ignore:return_value_discarded
	GameSession.connect("about_to_start", self, "_set_session_data")


func create(teams_count: int, slots_count: int) -> void:
	assert(_teams.empty(), "You should clear first")
	assert(slots_count >= 1, "The number of slots cannot be less than 1")
	assert(teams_count >= 1, "The number of teams cannot be less than 1")

	for index in range(teams_count):
		if index == 0 and not CmdArguments.server:
			# The first team should contain the host if it is not a headless server
			var slots: Array = [Slot.HOST] # TODO 4.0: Use array because of bug with resize in PoolIntArray (https://github.com/godotengine/godot/issues/31040)
			slots.resize(slots_count) # Will filled with zeroes that corresponds to EMPTY_SLOT
			_create_team(PoolIntArray(slots))
		else:
			_create_team(slots_count)


func clear() -> void:
	_truncate_teams(0)


func set_slots_count(count: int) -> void:
	if _teams.front().size() > count:
		for team in _teams:
			team.rpc("truncate", count)
		return

	for team in _teams:
		team.rpc("add_slots", count - team.size())


func set_teams_count(count: int) -> void:
	if count == 0:
		_teams.front().rset("team_number", Team.NO_TEAM_NUMBER)
		rpc("_truncate_teams", 1) # Remove all teams except one
		return

	_teams.front().team_number = 1
	if _teams.size() > count:
		rpc("_truncate_teams", count)
		return

	for _index in range(_teams.size(), count):
		rpc("_create_team", _teams.front().size())
		# Must be called on the server separately, as this function is also used
		# to send existing data to the connected client (therefore, cannot be marked as sync)
		_create_team(_teams.front().size())


func add_connected_player(connected_id: int) -> void:
	if not get_tree().is_network_server():
		return

	# Add player to the first empty slot
	var slot: Slot = _find_slot(Slot.EMPTY_SLOT)
	assert(slot != null, "There is no empty slots to add a new player")
	slot.id = connected_id

	# Send connected player data to other peers
	for peer_id in get_tree().get_network_connected_peers():
		if peer_id != connected_id:
			slot.rset_id(peer_id, "id", connected_id)

	# Send all data to the new player
	for team in _teams:
		rpc_id(connected_id, "_create_team", team.get_slot_ids())


func remove_disconnected_player(id: int) -> void:
	if not get_tree().is_network_server():
		return

	# Add player to the first empty slot
	var slot: Slot = _find_slot(id)
	assert(slot != null, "Disconnected player alredy does not exits")
	slot.rset("id", Slot.EMPTY_SLOT)


puppet func _create_team(slots) -> void:
	var team := Team.new(self, _teams.size() + 1, slots)
	if get_tree().is_network_server():
		# warning-ignore:return_value_discarded
		team.connect("filled_changed", self, "_check_if_filled_changed")
	_teams.append(team)


func _on_button_pressed(item: TreeItem, column: int, _button_idx: int) -> void:
	var wrapper: TreeItemWrapper = item.get_meta(TreeItemWrapper.WRAPPER_META)
	if wrapper is Team:
		match column:
			Team.Buttons.JOIN:
				rpc("_join_team", _teams.find(wrapper))
	else:
		match column:
			Slot.Buttons.KICK_PLAYER:
				emit_signal("player_kicked", wrapper.id)


master func _join_team(team_index: int) -> void:
	var previous_slot: Slot = _find_slot(get_tree().get_rpc_sender_id())
	var new_slot = _teams[team_index].find_slot(Slot.EMPTY_SLOT)
	if new_slot == null:
		return
	new_slot.rset("id", previous_slot.id)
	previous_slot.rset("id", Slot.EMPTY_SLOT)


puppetsync func _truncate_teams(size: int) -> void:
	Utils.truncate_and_free(_teams, size)


func _check_if_filled_changed() -> void:
	if _teams_full == _is_teams_full():
		return

	_teams_full = not _teams_full
	emit_signal("filled_changed", _teams_full)


func _find_slot(id: int) -> Slot:
	for team in _teams:
		var slot: Slot = team.find_slot(id)
		if slot != null:
			return slot
	return null


func _is_teams_full() -> bool:
	for team in _teams:
		if not team.is_full():
			return false
	return true


func _set_session_data() -> void:
	for team_idx in _teams.size():
		var team: Team = _teams[team_idx];
		for slot_idx in team.size():
			var id: int = team.get_slot(slot_idx).id
			if id != Slot.EMPTY_SLOT:
				GameSession.players[id] = PlayerInfo.new(team_idx)
