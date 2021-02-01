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

	if GameSession.get_teams_count() > 0:
		for i in GameSession.get_teams_count():
			var team: Team = GameSession.get_team(i)
			var team_item: TreeItem = _create_team(i)
			for j in team.get_players_count():
				_create_player_item(team_item, team.get_player(j))
	else:
		var team_item: TreeItem = _create_team(LobbyTeam.NO_TEAM_NUMBER)
		for i in GameSession.get_players_count():
			_create_player_item(team_item, GameSession.get_player(i))


func _create_team(team_number: int) -> TreeItem:
	var team_item: TreeItem = create_item(get_root())
	if team_number == LobbyTeam.NO_TEAM_NUMBER:
		team_item.set_text(0, "Players")
	else:
		team_item.set_text(0, "Team %d" % team_number)
	_disable_selection(team_item)
	return team_item


func _create_player_item(team_item: TreeItem, player: Player) -> void:
	var player_item: TreeItem = create_item(team_item)
	_disable_selection(player_item)

	player_item.set_text(Columns.ID, str(player.get_network_master()))
	player_item.set_text(Columns.KILLS, "0")
	player_item.set_text(Columns.DEATHS, "0")
	player_item.set_text(Columns.ASSISTS, "0")
	player_item.set_text(Columns.DAMAGE, "0")
	player_item.set_text(Columns.HEALING, "0")

	# warning-ignore:return_value_discarded
	player.get_statistic().connect("kills_changed", self, "_on_info_changed", [player_item, Columns.KILLS])
	# warning-ignore:return_value_discarded
	player.get_statistic().connect("deaths_changed", self, "_on_info_changed", [player_item, Columns.DEATHS])
	# warning-ignore:return_value_discarded
	player.get_statistic().connect("assists_changed", self, "_on_info_changed", [player_item, Columns.ASSISTS])
	# warning-ignore:return_value_discarded
	player.get_statistic().connect("damage_changed", self, "_on_info_changed", [player_item, Columns.DAMAGE])
	# warning-ignore:return_value_discarded
	player.get_statistic().connect("healing_changed", self, "_on_info_changed", [player_item, Columns.HEALING])


func _disable_selection(item: TreeItem) -> void:
	for i in range(columns):
		item.set_selectable(i, false)


func _on_info_changed(value: int, item: TreeItem, column: int) -> void:
	item.set_text(column, str(value))
