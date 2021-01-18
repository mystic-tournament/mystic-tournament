class_name ScoreboardTree
extends Tree


enum Columns {
	ID,
	KILLS,
	DEATHS,
	ASSISTS,
	DAMAGE,
	HEALING,
}

func create_items() -> void:
	# Create only once
	if get_root() != null:
		return

	var root: TreeItem = create_item()
	root.set_text(Columns.KILLS, "Kills")
	root.set_text(Columns.DEATHS, "Deaths")
	root.set_text(Columns.ASSISTS, "Assists")
	root.set_text(Columns.DAMAGE, "Damage")
	root.set_text(Columns.HEALING, "Healing")
	_disable_selection(root)

	var teams: Dictionary = {} # Contains team numbers as keys and TreeItem as values
	for id in GameSession.players:
		var player_info: PlayerInfo = GameSession.players[id]
		if not teams.has(player_info.team):
			var team_item: TreeItem = create_item(root)
			if player_info.team == LobbyTeam.NO_TEAM_NUMBER:
				team_item.set_text(0, "Players")
			else:
				team_item.set_text(0, "Team %d" % player_info.team)
			_disable_selection(team_item)
			teams[player_info.team] = team_item

		var player_item: TreeItem = create_item(teams[player_info.team])
		_disable_selection(player_item)

		player_item.set_text(Columns.ID, str(id))
		player_item.set_text(Columns.KILLS, "0")
		player_item.set_text(Columns.DEATHS, "0")
		player_item.set_text(Columns.ASSISTS, "0")
		player_item.set_text(Columns.DAMAGE, "0")
		player_item.set_text(Columns.HEALING, "0")

		# warning-ignore:return_value_discarded
		player_info.connect("kills_changed", self, "_on_info_changed", [player_item, Columns.KILLS])
		# warning-ignore:return_value_discarded
		player_info.connect("deaths_changed", self, "_on_info_changed", [player_item, Columns.DEATHS])
		# warning-ignore:return_value_discarded
		player_info.connect("assists_changed", self, "_on_info_changed", [player_item, Columns.ASSISTS])
		# warning-ignore:return_value_discarded
		player_info.connect("damage_changed", self, "_on_info_changed", [player_item, Columns.DAMAGE])
		# warning-ignore:return_value_discarded
		player_info.connect("healing_changed", self, "_on_info_changed", [player_item, Columns.HEALING])


func _disable_selection(item: TreeItem) -> void:
	for i in range(columns):
		item.set_selectable(i, false)


func _on_info_changed(value: int, item: TreeItem, column: int) -> void:
	item.set_text(column, str(value))
