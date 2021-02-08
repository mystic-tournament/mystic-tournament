class_name Deathmatch
extends BaseGamemode


const KillsScene: PackedScene = preload("res://ui/main_menu/custom_game/server_settings/gamemode_options/kills.tscn")

var kills_to_win: int


static func name() -> String:
	return "Deathmatch"


static func additional_settings() -> Array:
	return [KillsScene]


func _on_hero_died(by: BaseController, who: BaseController) -> void:
	._on_hero_died(by, who)

	if GameSession.get_teams_count() > 0:
		var team: Team = by.get_player().get_team()
		if team.get_statistic().kills > kills_to_win:
			emit_signal("game_over", team)
	else:
		var player: Player = by.get_player()
		if player.get_statistic().kills > kills_to_win:
			emit_signal("game_over", player)
