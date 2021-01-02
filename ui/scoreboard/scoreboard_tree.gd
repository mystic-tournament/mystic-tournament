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

var _players: Dictionary # Contains player ids as keys and TreeItem as values


func update_info() -> void:
	if get_root() == null:
		_create_items()

	for id in GameSession.players:
		var player_info: PlayerInfo = GameSession.players[id]
		var player_item: TreeItem = _players[id]
		player_item.set_text(Columns.ID, str(id))
		player_item.set_text(Columns.KILLS, str(player_info.kills))
		player_item.set_text(Columns.DEATHS, str(player_info.deaths))
		player_item.set_text(Columns.ASSISTS, str(player_info.assists))
		player_item.set_text(Columns.DAMAGE, str(player_info.damage))
		player_item.set_text(Columns.HEALING, str(player_info.healing))


func _create_items() -> void:
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
			if player_info.team == Team.NO_TEAM_NUMBER:
				team_item.set_text(0, "Players")
			else:
				team_item.set_text(0, "Team %d" % player_info.team)
			_disable_selection(team_item)
			teams[player_info.team] = team_item
		var player_item: TreeItem = create_item(teams[player_info.team])
		_disable_selection(player_item)
		_players[id] = player_item


func _disable_selection(item: TreeItem) -> void:
	for i in range(columns):
		item.set_selectable(i, false)
