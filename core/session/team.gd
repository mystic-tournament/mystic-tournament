class_name Team


var _players: Array
var _statistic := Statistic.new()


func get_players_count() -> int:
	return _players.size()


func get_player(idx: int) -> Player:
	return _players[idx]


func get_statistic() -> Statistic:
	return _statistic


func add_player(player: Player) -> void:
	assert(not player in _players, "The team already contains this player")
	assert(player._team == null, "The player is already in a team")
	_players.append(player)
	player._team = self


func remove_player(player: Player) -> void:
	assert(player in _players, "The team does not contain this player")
	_players.remove(_players.find(player))
	player._team = null
