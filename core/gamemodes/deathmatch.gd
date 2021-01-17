class_name Deathmatch
extends BaseGamemode


var kills_to_win: int
var team_kills: Dictionary


static func name() -> String:
	return "Deathmatch"


static func additional_settings() -> Array:
	return [preload("res://ui/main_menu/custom_game/server_settings/gamemode_options/kills.tscn")]


func _on_hero_died(by: BaseHero, who: BaseHero) -> void:
	._on_hero_died(by, who)
	var id: int = by.get_network_master()
	var team: int = GameSession.players[id].team
	team_kills[team] += 1
